start_state = 1
lfsr = start_state
period = 0


def print_str(str):
    if hex(str)[-2] == 'x':
        print(hex(str)[0], end="\t\t")
    else:
        print(hex(str)[-2], end="\t\t")


def print_hex():
    print(period, end="\t\t")
    print_str(start_state)
    print(hex(start_state)[-1], end="\t\t")
    print_str(period)
    print(hex(period)[-1], end="\t\t")
    print_str(lfsr)
    print(hex(lfsr)[-1])


print("period\tHEX5\tHEX4\tHEX3\tHEX2\tHEX1\tHEX0")

print_hex()

for i in range(14):
    bit = (lfsr ^ (lfsr << 2) ^ (lfsr << 4)) & 0x80
    lfsr = (lfsr << 1) | (bit >> 7)
    period += 1
    print_hex()
    # if lfsr == start_state:
    #     break
