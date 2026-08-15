import os
import sys
import argparse

import json
import base64

import expr_ctrl

import numpy as np

valid_code_distance = [3, 5, 7, 9]

physical_qubit_map = {
    3 : [20, 6, 7, 21, 24],
    5 : [19, 22, 20, 6, 7, 21, 24, 26, 40],
    7 : [32, 33, 19, 22, 20, 6, 7, 21, 24, 26, 40, 42, 43],
    9 : [52, 49, 48, 34, 32, 33, 19, 22, 20, 6, 7, 21, 24, 26, 40, 42, 43]
}


def load_record(code_distance, num_rounds, initial_state, begin, end, mapping, verbose=False):
    
    if verbose:
        print(f"# load: d={code_distance}, r={num_rounds}, i={initial_state}, range={begin}:{end}")
        
    filename = f"./record/record_dataset_device_d{code_distance}_r{num_rounds}_i{initial_state}.json"
    with open(filename, "r") as f:
        data = json.load(f)

    record_dataset = np.frombuffer(base64.b64decode(data['record_dataset']['data']),
                                   dtype=np.dtype(data['record_dataset']['dtype'])).reshape(data['record_dataset']['shape'])
    
    records = record_dataset[begin:end]

    if mapping:
        qubits_rounds = [[0 for i in range(64)] for _ in range(num_rounds)]
    else:
        qubits_rounds = [[0 for i in range(2*code_distance-1)] for _ in range(num_rounds)]

    result = []
        
    for record in records:
        if verbose:
            print("record=", record)
            
        for r,i in zip(record, data['record_info_list']):
            round_index = i['round_index']
            qubit_index = i['qubit_index']
            if mapping:
                physical_qubit = physical_qubit_map[code_distance][qubit_index]
                if verbose:
                    print(f"round={round_index}, qubit={qubit_index}->{physical_qubit}, value={r}")
                qubits_rounds[round_index][physical_qubit] = int(r)
            else:
                if verbose:
                    print(f"round={round_index}, qubit={qubit_index}, value={r}")
                qubits_rounds[round_index][qubit_index] = int(r)

        if verbose:
            for qubits in qubits_rounds:
                if verbose:
                    print(qubits)

        qubits_bytevector_rounds = [pack_bitvector(qubits) for qubits in qubits_rounds]

        if verbose:
            for qubits_bytevector in qubits_bytevector_rounds:
                if verbose:
                    print([hex(x) for x in qubits_bytevector])
                
        result.append(qubits_bytevector_rounds)

    return result

def pack_bitvector(bits):
    bits = bits + [0]*(8-len(bits)) # padding to align 8bit
    result = [
        int("".join(map(str, bits[i:i+8])), 2) for i in range(0, len(bits), 8)
    ]
    return result

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    
    parser.add_argument('-d', '--distance', default=3, type=int)
    parser.add_argument('-r', '--rounds', default=2, type=int)
    parser.add_argument('-i', '--init', default=0, type=int)
    parser.add_argument('-b', '--begin', default=0, type=int)
    parser.add_argument('-e', '--end', default=0, type=int)
    parser.add_argument('--without-mapping', action='store_false')
    parser.add_argument('--verbose', action='store_true')
    parser.add_argument('--ipaddr', default='10.0.0.16')
    
    args = parser.parse_args()
    
    if args.rounds < 2 or 8 < args.rounds:
        print('rounds in 2..8')
        sys.exit(0)
    
    if not args.distance in valid_code_distance:
        print('distance = 3, 5, 7, 9')
        sys.exit(0)
    
    if args.end <= args.begin:
        args.end = args.begin
    
    result = load_record(args.distance, args.rounds, args.init, args.begin, args.end+1, args.without_mapping, args.verbose)
    
    expr = expr_ctrl.ExprCtrl(args.ipaddr)
    
    i = 0
    rounds = 0
    for qubits_bytevector_rounds in result:
        for qubits_bytevector in qubits_bytevector_rounds:
            hexstr = ''.join(f'{x:02x}' for x in qubits_bytevector)
            v = int(hexstr, 16) << 64
            if args.verbose:
                print('{:02x}: {:032x}'.format(i, v))
            expr.write_memory(i, v)
            i += 1
            rounds += 1

    for i in range(rounds):
        v = expr.read_memory(i)
        print('{:02x}:'.format(i), v.hex(" "))
