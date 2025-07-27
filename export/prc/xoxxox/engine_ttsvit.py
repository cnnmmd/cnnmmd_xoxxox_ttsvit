#---------------------------------------------------------------------------

import io
import glob
import json
import numpy as np
import wave
from style_bert_vits2.nlp import bert_models
from style_bert_vits2.constants import Languages
from style_bert_vits2.tts_model import TTSModel
from xoxxox.shared import Custom
from xoxxox.params import Config
from xoxxox.params_vit import AppTts

#---------------------------------------------------------------------------

class TtsPrc():

  def __init__(self, config="xoxxox/config_ttsvit_000", **dicprm):
    diccnf = Custom.update(config, dicprm)
    self.keyspk = "0"
    self.nmodel = None
    self.device = diccnf["device"]
    bert_models.load_model(Languages.JP, "ku-nlp/deberta-v2-large-japanese-char-wwm")
    bert_models.load_tokenizer(Languages.JP, "ku-nlp/deberta-v2-large-japanese-char-wwm")
    self.dicspk = {}
    l = glob.glob(Config.dircnf + "/" + AppTts.glbvit + Config.expjsn)
    for p in l:
      with open(p, "r") as f:
        d = json.load(f)
        self.dicspk.update(d)

  def status(self, config="xoxxox/config_ttsvit_000", **dicprm):
    diccnf = Custom.update(config, dicprm)
    if self.keyspk != diccnf["keyspk"]:
      self.keyspk = diccnf["keyspk"]
      self.nmodel = TTSModel(
        model_path=self.dicspk[self.keyspk]["vce"],
        config_path=self.dicspk[self.keyspk]["cfg"],
        style_vec_path=self.dicspk[self.keyspk]["sty"],
        device=self.device,
      )
    self.keysty = diccnf["keysty"]

  def infere(self, txtreq):
    if (self.keysty is None) or (self.keysty == ""):
      ratefr, arrsnd = self.nmodel.infer(text=txtreq)
    else:
      ratefr, arrsnd = self.nmodel.infer(text=txtreq, style=self.keysty)
    return self.cnvwav(arrsnd, ratefr)

  def cnvwav(self, arrsnd, ratefr):
    with io.BytesIO() as b:
      with wave.open(b, "wb") as f:
        f.setnchannels(1)
        f.setsampwidth(2)
        f.setframerate(ratefr)
        f.writeframes(arrsnd.astype(np.int16).tobytes())
      datwav = b.getvalue()
    return datwav
