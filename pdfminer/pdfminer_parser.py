import sys
import json
from io import StringIO
from pdfminer.high_level import extract_text_to_fp
from pdfminer.layout import LAParams

def extract_text(pdf_path):
    output_string = StringIO()
    with open(pdf_path, 'rb') as fin:
        extract_text_to_fp(fin, output_string, laparams=LAParams(), output_type='text', codec='utf-8')
    return output_string.getvalue().strip()

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Usage: python pdfminer_parser.py <pdf_file> [-j]')
        sys.exit(1)

    pdf_path = sys.argv[1]
    json_output = '-j' in sys.argv

    text = extract_text(pdf_path)

    if json_output:
        print(json.dumps({'text': text}))
    else:
        print(text)
