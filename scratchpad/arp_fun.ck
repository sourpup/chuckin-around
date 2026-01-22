//<<<"start">>>;

TriOsc osc => ADSR env1 => dac;
TriOsc osc2 => ADSR env2 => dac;

1::second / 2 => dur beat;
(beat/3, 2*beat/3, 0, 1::ms) => env1.set;
(1::ms,  beat/8,   0, 1::ms) => env2.set;

0.1 => osc.gain;
0.05 => osc2.gain;

48 => int offset;

fun void arp(int notes[], int position) {
  for (0 => int j; j < 4; j++){
    for (0 => int i; i < notes.cap(); i++) {
      Std.mtof(notes[i] + offset + position) => osc.freq;
      1 => env1.keyOn;
      beat => now;
    }
  }
}


[0, 4, 7, 12] @=> int major[];
[0, 3, 7, 12] @=> int minor[];

150::ms => beat;

arp(major, 0);
arp(minor, -3);
arp(major, 5);
arp(major, 7);


2::second => beat;
(beat/2, beat/2, 0, 1::ms) => env1.set;
(1::ms,  beat/8,   0, 1::ms) => env2.set;

fun void arp2(int notes1[], int notes2[], int position) {
  for (0 => int i; i < notes1.cap(); i++) {
    Std.mtof(notes1[i] + offset + position) => osc.freq;
    1 => env1.keyOn;
    for (0 => int j; j < notes2.cap(); j++) {
      Std.mtof(notes2[j] + offset + position) => osc2.freq;
      1 => env2.keyOn;
      beat / 8 => now;
    }
  }
}

for (0 => int i; i < 2; i++){
  arp2(minor, minor, 0);

  arp2(major, major, -4);

  arp2(major, major, -2);

  arp2(minor, minor, -5);

  1::second / 2 => beat;
  (beat/2, beat/2, 0, 1::ms) => env1.set;
  (1::ms,  beat/8,   0, 1::ms) => env2.set;
  2::second => beat;

}
