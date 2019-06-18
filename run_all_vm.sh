#!/usr/bin/env bash

set -xe

dir = '/home/anhnguyen'

tuda_corpus_path= dir + "/deepspeech-german/corpus/tuda"
voxforge_corpus_path= dir + "/deepspeech-german/corpus/voxforge_de"
swc_corpus_path= dir + "/deepspeech-german/corpus/swc"
text_corpus_path= dir + "/deepspeech-german/corpus/German_sentences_8mil_filtered_maryfied.txt"

exp_path= dir + "/deepspeech-german/exp"

kenlm_bin= dir + "/deepspeech-german/tools/kenlm/build/bin"
deepspeech= dir + "/deepspeech-german/DeepSpeech"

# Download/Prepare Data
# ./prepare_data.py $exp_path/data --tuda $tuda_corpus_path --voxforge $voxforge_corpus_path --swc $swc_corpus_path
./prepare_data.py $exp_path/data --tuda $tuda_corpus_path --swc $swc_corpus_path

# Create LM
./prepare_vocab.py $text_corpus_path $exp_path/cleaned_vocab.txt --training_csv $exp_path/data/train.csv

$kenlm_bin/lmplz --text $exp_path/cleaned_vocab.txt --arpa $exp_path/words.arpa --o 3
$kenlm_bin/build_binary -T -s $exp_path/words.arpa  $exp_path/lm.binary

# Create trie
$deepspeech/native_client/generate_trie data/alphabet.txt $exp_path/lm.binary $exp_path/cleaned_vocab.txt $exp_path/trie

# Train
./run_training.sh $deepspeech $(realpath data/alphabet.txt) $exp_path
