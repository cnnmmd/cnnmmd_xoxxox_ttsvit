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
      if cd "${pthapp}"/mdl/${mdltgt}
      then
        for i in "${lstrsc[@]}"
        do
          curl -LO "${i}"
        done
      fi
    fi
  fi
}

if ! docker inspect ${imgtgt} > /dev/null 2>&1
then
  if cd ${pthdoc}
  then
    test -e ${txtcns} || curl https://raw.githubusercontent.com/litagin02/Style-Bert-VITS2/master/requirements.txt > ${txtcns}
  fi
fi

addimg ${imgtgt} "${cnfimg}" "${pthdoc}"
test -d "${pthapp}" || mkdir "${pthapp}"
if cd "${pthapp}"
then
  test -d hgf || mkdir hgf
  test -d mdl || mkdir mdl

  getmdl amitaro \
  https://huggingface.co/litagin/sbv2_amitaro \
  https://huggingface.co/litagin/sbv2_amitaro/resolve/main/amitaro/amitaro.safetensors \
  https://huggingface.co/litagin/sbv2_amitaro/resolve/main/amitaro/config.json \
  https://huggingface.co/litagin/sbv2_amitaro/resolve/main/amitaro/style_vectors.npy

  getmdl tsukuyomi-chan \
  https://huggingface.co/ayousanz/tsukuyomi-chan-style-bert-vits2-model \
  https://huggingface.co/ayousanz/tsukuyomi-chan-style-bert-vits2-model/resolve/main/config.json \
  https://huggingface.co/ayousanz/tsukuyomi-chan-style-bert-vits2-model/resolve/main/style_vectors.npy \
  https://huggingface.co/ayousanz/tsukuyomi-chan-style-bert-vits2-model/resolve/main/tsukuyomi-chan_e77_s2000.safetensors

  getmdl Rinne \
  https://huggingface.co/RinneAi/Rinne_Style-Bert-VITS2 \
  https://huggingface.co/RinneAi/Rinne_Style-Bert-VITS2/resolve/main/model_assets/Rinne/config.json \
  https://huggingface.co/RinneAi/Rinne_Style-Bert-VITS2/resolve/main/model_assets/Rinne/style_vectors.npy \
  https://huggingface.co/RinneAi/Rinne_Style-Bert-VITS2/resolve/main/model_assets/Rinne/Rinne.safetensors
fi
