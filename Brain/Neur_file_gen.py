import random

def generate_fixed_bits(random_bits):
    bit_0 = '1'  # bit[0] = 1
    bits_7_1 = '0000011'  # bits[7:1] = 3
    bit_8 = '1'  # bit[8] = 1
    bits_16_9 = '00010100'  # bits[16:9] = 20
    bit_17 = '0'  # bit[17] = 0
    bits_69_18 = '0' * 52  # bits[69:18] = 0
    bits_77_70 = format(random_bits, '08b')  # bits[77:70] = random value from 1 to 16
    bits_126_78 = '0' * 49  # bits[126:78] = 0
    bit_127 = '0'  # bit[127] = 0
    
    # Combine all the parts
    entry = bit_127 + bits_126_78 + bits_77_70 + bits_69_18 + bit_17 + bits_16_9 + bit_8 + bits_7_1 + bit_0
    return entry

# Open a file to write
with open('Neur_Mem.txt', 'w') as file:
    for _ in range(256):  # We want 256 entries
        random_bits = random.randint(1, 16)  # Generate a random number from 1 to 16
        entry = generate_fixed_bits(random_bits)
        file.write(entry + '\n')  # Write each entry to a new line

print('File written successfully.')
