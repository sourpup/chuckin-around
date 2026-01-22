class SynthVoice extends Chugraph {
  SawOsc osc => LPF lpf => ADSR adsr => outlet;

  0.2 => osc.gain;
  500 => lpf.freq;

  1::ms   => adsr.attackTime;
  300::ms  => adsr.decayTime;
  0       => adsr.sustainLevel;
  1::ms   => adsr.releaseTime;

  24  => int offset;
  500 => int filterEnv;

  fun void keyOn(int noteNumber) {
    Std.mtof(offset+noteNumber);
    1 => adsr.keyOn;
    spork ~ filterEnvelope();
  }

  fun void filterEnvelope() {
    lpf.freq() => float startFreq;

    // .state() of adsr has 5 states, with 4 being complete. however, if the user never .keyOff's, then it will never reach 4 and will just be reset to 0
    while(!(adsr.state() != 0 && adsr.value() == 0)){
      (filterEnv * adsr.value()) + startFreq => lpf.freq;
      20::ms => now;
    }
  }
}


SynthVoice voice => dac;
voice.keyOn(24);
1::second => now;
