# download voxforge data

import os
from audiomate.corpus import io


env = os.getenv('ENV', 'local')

if env == 'vm':
    dir = '/home/anhnguyen'
else:
    dir = '/Users/anhnguyen/Downloads/projects/imperial-project' 

voxforge_corpus_path= dir + "/deepspeech-german/corpus/voxforge_de"

dl = io.VoxforgeDownloader(lang='de')
dl.download(voxforge_corpus_path)