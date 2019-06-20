# /path/to/swc-code = /Users/anhnguyen/Downloads/projects/imperial-project/deepspeech-german/code/swc-code/prepare_audio.py
# for article_dir in ./*; do python3 /Users/anhnguyen/Downloads/projects/imperial-project/deepspeech-german/code/swc-code/prepare_audio.py $article_dir; done

# /path/to/articles = /Volumes/Toshiba-adhn/corpus/swc/german
# java -jar /Users/anhnguyen/Downloads/projects/imperial-project/deepspeech-german/code/swc-code/Aligner/target/Aligner.jar extractsnippets kaldi /dev/null /Volumes/Toshiba-adhn/corpus/swc/german /Users/anhnguyen/Downloads/projects/imperial-project/deepspeech-german/code/output/

#-------------------------------------------------#
# /path/to/swc-code = /home/anhnguyen/deepspeech-german/code/swc-code/prepare_audio.py
# for article_dir in ./*; do python3 /home/anhnguyen/deepspeech-german/code/swc-code/prepare_audio.py $article_dir; done

# /path/to/articles = /home/anhnguyen/deepspeech-german/corpus/swc/german
# java -jar /home/anhnguyen/deepspeech-german/code/swc-code/Aligner/target/Aligner.jar extractsnippets kaldi /dev/null /home/anhnguyen/deepspeech-german/corpus/swc/german /home/anhnguyen/deepspeech-german/code/output/


import sys
import os
import re

scp_file = '/Users/anhnguyen/Downloads/projects/imperial-project/deepspeech-german/code/output/wav.scp'
article_dir = '../../corpus/swc/german'

# scp_file = sys.argv[1]
# article_dir = sys.argv[2]

pattern = re.compile(r'.*articles/(.*)/audio.*')

entries = []

with open(scp_file, 'r') as f:
    print('get here')
    for line in f:
        parts = line.strip().split(sep=' ', maxsplit=1)
        idx = parts[0]
        match = pattern.match(parts[1])

        print(match)
        if match is not None:
            article_id = match.group(1)
            path = os.path.join(article_dir, article_id, 'audio.wav')
            print(path)
            entries.append('{} {}'.format(idx, path))

with open(scp_file, 'w') as f:
    f.write('\n'.join(entries))