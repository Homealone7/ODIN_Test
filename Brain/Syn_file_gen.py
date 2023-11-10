import random

def generate_random_nibbles():
    # Generate eight 4-bit random values between 1 and 15 to make a 32-bit line
    return ''.join(format(random.randint(1, 15), '04b') for _ in range(8))

# Open a file to write
with open('Syn_Mem.txt', 'w') as file:
    for _ in range(8192):  # We want 8192 entries
        entry = generate_random_nibbles()
        file.write(entry + '\n')  # Write each entry to a new line

print('File written successfully.')
