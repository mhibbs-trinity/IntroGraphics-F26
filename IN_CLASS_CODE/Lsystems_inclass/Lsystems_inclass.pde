String[] koch = new String [4];
String[] hilbert = new String [5];
String[] dragon = new String [11];
String[] tree = new String [6];
String[] bush = new String [4];
String[] gosper = new String[4];

/* Mode variable to choose which LSystem to use */
public enum Mode { KOCH, HILBERT, DRAGON, TREE, BUSH, GOSPER }
Mode mode = Mode.KOCH;

HashMap<Character,String> rules = new HashMap<Character,String>();

void setup() {
  rules.put('A',"A-B--B+A++AA+B-");
  rules.put('B',"+A-BB--B-A++A+B"); 
  
  size(800,800);
  koch[0] = "F";
  koch[1] = "F-F++F-F";
  koch[2] = "F-F++F-F-F-F++F-F++F-F++F-F-F-F++F-F";
  koch[3] = "F-F++F-F-F-F++F-F++F-F++F-F-F-F++F-F-F-F++F-F-F-F++F-F++F-F++F-F-F-F++F-F++F-F++F-F-F-F++F-F++F-F++F-F-F-F++F-F-F-F++F-F-F-F++F-F++F-F++F-F-F-F++F-F";
  hilbert[0] = "A";
  hilbert[1] = "-BF+AFA+FB-";
  hilbert[2] = "-+AF-BFB-FA+F+-BF+AFA+FB-F-BF+AFA+FB-+F+AF-BFB-FA+-";
  hilbert[3] = "-+-BF+AFA+FB-F-+AF-BFB-FA+F+AF-BFB-FA+-F-BF+AFA+FB-+F+-+AF-BFB-FA+F+-BF+AFA+FB-F-BF+AFA+FB-+F+AF-BFB-FA+-F-+AF-BFB-FA+F+-BF+AFA+FB-F-BF+AFA+FB-+F+AF-BFB-FA+-+F+-BF+AFA+FB-F-+AF-BFB-FA+F+AF-BFB-FA+-F-BF+AFA+FB-+-";
  hilbert[4] = "-+-+AF-BFB-FA+F+-BF+AFA+FB-F-BF+AFA+FB-+F+AF-BFB-FA+-F-+-BF+AFA+FB-F-+AF-BFB-FA+F+AF-BFB-FA+-F-BF+AFA+FB-+F+-BF+AFA+FB-F-+AF-BFB-FA+F+AF-BFB-FA+-F-BF+AFA+FB-+-F-+AF-BFB-FA+F+-BF+AFA+FB-F-BF+AFA+FB-+F+AF-BFB-FA+-+F+-+-BF+AFA+FB-F-+AF-BFB-FA+F+AF-BFB-FA+-F-BF+AFA+FB-+F+-+AF-BFB-FA+F+-BF+AFA+FB-F-BF+AFA+FB-+F+AF-BFB-FA+-F-+AF-BFB-FA+F+-BF+AFA+FB-F-BF+AFA+FB-+F+AF-BFB-FA+-+F+-BF+AFA+FB-F-+AF-BFB-FA+F+AF-BFB-FA+-F-BF+AFA+FB-+-F-+-BF+AFA+FB-F-+AF-BFB-FA+F+AF-BFB-FA+-F-BF+AFA+FB-+F+-+AF-BFB-FA+F+-BF+AFA+FB-F-BF+AFA+FB-+F+AF-BFB-FA+-F-+AF-BFB-FA+F+-BF+AFA+FB-F-BF+AFA+FB-+F+AF-BFB-FA+-+F+-BF+AFA+FB-F-+AF-BFB-FA+F+AF-BFB-FA+-F-BF+AFA+FB-+-+F+-+AF-BFB-FA+F+-BF+AFA+FB-F-BF+AFA+FB-+F+AF-BFB-FA+-F-+-BF+AFA+FB-F-+AF-BFB-FA+F+AF-BFB-FA+-F-BF+AFA+FB-+F+-BF+AFA+FB-F-+AF-BFB-FA+F+AF-BFB-FA+-F-BF+AFA+FB-+-F-+AF-BFB-FA+F+-BF+AFA+FB-F-BF+AFA+FB-+F+AF-BFB-FA+-+-";
  dragon[0] = "FX";
  dragon[1] = "FX+YF";
  dragon[2] = "FX+YF+FX-YF";
  dragon[3] = "FX+YF+FX-YF+FX+YF-FX-YF";
  dragon[4] = "FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF";
  dragon[5] = "FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF";
  dragon[6] = "FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF";
  dragon[7] = "FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF";
  dragon[8] = "FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF";
  dragon[9] = "FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF";
  dragon[10] = "FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF+FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF+FX+YF+FX-YF-FX+YF-FX-YF-FX+YF+FX-YF+FX+YF-FX-YF-FX+YF+FX-YF-FX+YF-FX-YF";
  tree[0] = "0";
  tree[1] = "1[-0]+0";
  tree[2] = "11[-1[-0]+0]+1[-0]+0";
  tree[3] = "1111[-11[-1[-0]+0]+1[-0]+0]+11[-1[-0]+0]+1[-0]+0";
  tree[4] = "11111111[-1111[-11[-1[-0]+0]+1[-0]+0]+11[-1[-0]+0]+1[-0]+0]+1111[-11[-1[-0]+0]+1[-0]+0]+11[-1[-0]+0]+1[-0]+0";
  tree[5] = "1111111111111111[-11111111[-1111[-11[-1[-0]+0]+1[-0]+0]+11[-1[-0]+0]+1[-0]+0]+1111[-11[-1[-0]+0]+1[-0]+0]+11[-1[-0]+0]+1[-0]+0]+11111111[-1111[-11[-1[-0]+0]+1[-0]+0]+11[-1[-0]+0]+1[-0]+0]+1111[-11[-1[-0]+0]+1[-0]+0]+11[-1[-0]+0]+1[-0]+0";
  bush[0] = "F";
  bush[1] = "FF-[-F+F+F]+[+F-F-F]";
  bush[2] = "FF-[-F+F+F]+[+F-F-F]FF-[-F+F+F]+[+F-F-F]-[-FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]]+[+FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]]";
  bush[3] = "FF-[-F+F+F]+[+F-F-F]FF-[-F+F+F]+[+F-F-F]-[-FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]]+[+FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]]FF-[-F+F+F]+[+F-F-F]FF-[-F+F+F]+[+F-F-F]-[-FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]]+[+FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]]-[-FF-[-F+F+F]+[+F-F-F]FF-[-F+F+F]+[+F-F-F]-[-FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]]+[+FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]]+FF-[-F+F+F]+[+F-F-F]FF-[-F+F+F]+[+F-F-F]-[-FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]]+[+FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]]+FF-[-F+F+F]+[+F-F-F]FF-[-F+F+F]+[+F-F-F]-[-FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]]+[+FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]]]+[+FF-[-F+F+F]+[+F-F-F]FF-[-F+F+F]+[+F-F-F]-[-FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]]+[+FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]]-FF-[-F+F+F]+[+F-F-F]FF-[-F+F+F]+[+F-F-F]-[-FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]]+[+FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]]-FF-[-F+F+F]+[+F-F-F]FF-[-F+F+F]+[+F-F-F]-[-FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]+FF-[-F+F+F]+[+F-F-F]]+[+FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]-FF-[-F+F+F]+[+F-F-F]]]";
  gosper[0] = "A-B--B+A++AA+B-";
  gosper[1] = "A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-";
  gosper[2] = "A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B+A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B-";
  gosper[3] = "A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B+A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B-A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B-A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B+A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B+A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B+A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B-A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B+A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B--+A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B-A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B--+A-BB--B-A++A+B+A-B--B+A++AA+B-++A-B--B+A++AA+B-A-B--B+A++AA+B-++A-BB--B-A++A+B-++A-B--B+A++AA+B--+A-BB--B-A++A+B+A-BB--B-A++A+B--+A-BB--B-A++A+B-A-B--B+A++AA+B-++A-B--B+A++AA+B-++A-BB--B-A++A+B-";
}

int level=0;
void draw() {
  background(0);
  stroke(255);
  strokeWeight(3);
  
  if(mode == Mode.KOCH) {
    translate(width/2,0);
    String s = koch[level];
    float step = height / pow(3,level);
    for(int i=0; i<s.length(); i++) {
      char c = s.charAt(i);
      if(c == 'F') {
        line(0,0, 0,step);
        translate(0,step);
      } else if(c == '+') {
        rotate(PI/3);
      } else if(c == '-') {
        rotate(-PI/3);
      }
    }
  }
  
  if(mode == Mode.HILBERT) {
    
  }
  
  if(mode == Mode.GOSPER) {
    
  }
  
  if(mode == Mode.TREE) {
    
  }
  
  if(mode == Mode.BUSH) {
    
  }
  
  if(mode == Mode.DRAGON) {
    
  }
  
}

void doDragon() {
  
}


void keyPressed() {
  if(key == ' ') { noLoop(); }
  if(key == 'a') { loop(); }
  if(keyCode == LEFT || keyCode == DOWN) {
    level--;
    if(level < 0) level = 0;
  }
  if(keyCode == RIGHT || keyCode == UP) {
    level++;
    if(mode == Mode.KOCH && level > 3) level = 3;
    if(mode == Mode.HILBERT && level > 4) level = 4;
    if(mode == Mode.DRAGON && level > 10) level = 10;
    if(mode == Mode.TREE && level > 5) level = 5;
    if(mode == Mode.BUSH && level > 3) level = 3;
    if(mode == Mode.GOSPER && level > 3) level = 3;
  }
  if(key == 'k' || key == 'K') { mode = Mode.KOCH; level = 0; }
  if(key == 'h' || key == 'H') { mode = Mode.HILBERT; level = 0; }
  if(key == 'd' || key == 'D') { mode = Mode.DRAGON; level = 0; }
  if(key == 't' || key == 'T') { mode = Mode.TREE; level = 0; }
  if(key == 'b' || key == 'B') { mode = Mode.BUSH; level = 0; }
  if(key == 'g' || key == 'G') { mode = Mode.GOSPER; level = 0; }
}
