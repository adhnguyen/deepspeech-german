# !/usr/bin/env bash

set -xe

dir="/Users/anhnguyen/Downloads/projects/imperial-project"
corpus_dir="/Volumes/Toshiba-adhn/corpus"

tuda_corpus_path="$corpus_dir/tuda"
voxforge_corpus_path="$corpus_dir/voxforge_de"
swc_corpus_path="$dir/deepspeech-german/code/output"
text_corpus_path="$corpus_dir/German_sentences_8mil_filtered_maryfied.txt"

exp_path="$corpus_dir/deepspeech-german/exp"

kenlm_bin="$dir/deepspeech-german/tools/kenlm/build/bin"
deepspeech="$dir/deepspeech-german/code/DeepSpeech"

# Download/Prepare Data
./prepare_data.py $exp_path/data --tuda $tuda_corpus_path --voxforge $voxforge_corpus_path --swc $swc_corpus_path
# ./prepare_data.py $exp_path/data --tuda $tuda_corpus_path --swc $swc_corpus_path

# Create LM
./prepare_vocab.py $text_corpus_path $exp_path/cleaned_vocab.txt --training_csv $exp_path/data/train.csv

$kenlm_bin/lmplz --text $exp_path/cleaned_vocab.txt --arpa $exp_path/words.arpa --o 3
$kenlm_bin/build_binary -T -s $exp_path/words.arpa  $exp_path/lm.binary

# Create trie
$deepspeech/native_client/generate_trie data/alphabet.txt $exp_path/lm.binary $exp_path/cleaned_vocab.txt $exp_path/trie

# Train
./run_training.sh $deepspeech $(realpath data/alphabet.txt) $exp_path
