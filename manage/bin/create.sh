#!/bin/bash

pthtop="$(cd "$(dirname "${0}")/../../../.." && pwd)"
source "${pthtop}"/manage/lib/params.sh
source "${pthtop}"/manage/lib/shared.sh
source "${pthcrr}"/params.sh

pthapp="${pthsrc}"/appvit
txtcns='cnsver.txt'

function getmdl {
  local mdltgt=${1} ; shift
  local mdlurl=${1} ; shift
  local lstrsc=("${@}")

  if test ! -d "${pthapp}"/mdl/${mdltgt}
  then
    if cnfrtn "import: ${mdltgt}: ${mdlurl}"
    then
      mkdir "${pthapp}"/mdl/${mdltgt}
      cd "${pthapp}"/mdl/${mdltgt}
      for i in "${lstrsc[@]}"
      do
        curl -LO "${i}"
      done
    fi
  fi
}

if ! docker inspect ${imgtgt} > /dev/null 2>&1
then
  cd ${pthdoc}
  test -e ${txtcns} || curl https://raw.githubusercontent.com/litagin02/Style-Bert-VITS2/master/requirements.txt > ${txtcns}
fi

addimg ${imgtgt} "${cnfimg}" "${pthdoc}"
test -d "${pthapp}" || mkdir "${pthapp}"
cd "${pthapp}"
test -d hgf || mkdir hgf
test -d mdl || mkdir mdl

getmdl amitaro \
https://huggingface.co/litagin/sbv2_amitaro/tree/main/amitaro \
https://huggingface.co/litagin/sbv2_amitaro/resolve/main/amitaro/amitaro.safetensors \
https://huggingface.co/litagin/sbv2_amitaro/resolve/main/amitaro/config.json \
https://huggingface.co/litagin/sbv2_amitaro/resolve/main/amitaro/style_vectors.npy

getmdl Anneli \
https://huggingface.co/kaunista/kaunista-style-bert-vits2-models/tree/main/Anneli \
https://huggingface.co/kaunista/kaunista-style-bert-vits2-models/resolve/main/Anneli/Anneli_e116_s32000.safetensors \
https://huggingface.co/kaunista/kaunista-style-bert-vits2-models/resolve/main/Anneli/config.json \
https://huggingface.co/kaunista/kaunista-style-bert-vits2-models/resolve/main/Anneli/style_vectors.npy
