import re

PATTERN = r"^(?!.*(\d)(?:-?\1){3})[456]\d{3}(-?\d{4}){3}$"


def is_valid_creditcard(sequence):
    if bool(re.match(PATTERN, sequence)):
        print('Valid')
    else:
        print('Invalid')


num_inputs = int(input("Enter number of cards to be validated:\n"))

for i in range(0, num_inputs):
    sequence = raw_input("enter card details:\n")
    is_valid_creditcard(sequence)