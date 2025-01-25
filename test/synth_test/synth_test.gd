extends Node3D

var music_player = MusicPlayer.new(self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Blubb")
	
	music_player.initialize()
	music_player.start_streaming()
	music_player.change_filter(2)
	music_player.change_filter_power(20)
	
	music_player.change_instrument(9)
	
	music_player.play_note(69) # Nice
	
	#music_player.play_tune("/*\n   [FC-FDS] METROID - ENDING - (C)Nintendo 1986 by LinearDrive\n   date:2010-11-21初版\n   JASRAC:086-2289-2\n*/\n\n\n#TITLE{[FC-FDS] METROID - ENDING - (C)Nintendo 1986};\n#REV;\n#FPS 600;\n\n\n//envelope for tone\n#TABLE  1 { (104,40)30        | 40 };\n#TABLE  2 {  (16,64)120,64,48 | 48 };\n#TABLE  3 {  (16,64)210,64,48 | 48 };\n#TABLE  5 {  (16,88)60        | 88 };\n\n//envelope for noise\n#TABLE 15 { (48,0)33 |0 };\n#TABLE 16 { (48,0)100|0 };\n#TABLE 17 { (80,0)37 |0 };\n\n\n/* 矩形波１ */\n#A=\n   %1 @6,63,0,0,63,0 v16 x128 o3 l16 q8 @q0 na1\n   [ aaarrraaaraaaaar ]10 >\n   [ a4>f+4e4c+4<f+a>df+a4f+4d4<b4.>d8<ef+gaa4b4.>d8<g4>g4< ]2 <\n   g4g4f+4f+4>c4c4<b4b4a+4a+4a4a4g+4g+4a4a4 >\n   [ aaarrraaaraaaaar ]2 >\n   [ dddrrrdddrdddddr ]2 < \n   [ f+2g2g2g2 ]4 >>>\n   [ a4g4f+4e4g4f+4d4e4 ]6 <<<\n   [ d8d8d8d8r8<f+8f+8f+8e8e8e8e8a8a8a8a8r8f+8f+8f+8f+8f+8f+8r8 g6d6e6 a+6a6g6> ]2 >\n   [ f+gf+gabab>dedeef+ef+< ]8 <\n   [ dddrrrdddrdddddr<a+a+a+rrra+a+>crcccccr ]3\n   [ dddrrrdddrdddddr ]2 < \n   d1r4drddd4&d16\n;\n\n\n/* 矩形波２ */\n#B=\n   %1 @6,63,0,0,47,0 v16 x128 o4 l16 q8 @q1\n   na2\n   [ e1a1g+1g1 ]2 e1e1 >\n   [ df+a>df+4e4d4<a2f+2b2d4>d8<af+e2b2 ]2\n   [ e2f+4d4d4c4e4d4a+4e4d4a4f8g+8b4g4g4 ]2\n   [ d4a4>d4<a4 ]8 >\n   [ d1e2g2f+1g2a+2 ]2 d1e2g2f+1g2a+2\n   [ a8<a8>g8<a8>f+8<a8>e8<a8>g8<g8>f+8<g8>d8<g8>e8<g8> ]8 <\n   na3\n   [ aaarrraaaraaaaarfffrrrffgrgggggr ]3\n   [ aaarrraaaraaaaar ]2 <\n   a1r4araaa4&a16\n;\n\n\n/* 三角波 */\n#C=\n   %1 @8,63,0,0,63,0 v16 o3 l16 q8 @q1\n   [ aaarrraaaraaaaar ]10 >\n   q4 [ d4d4c+4c+4<b4b4a4a4g4g4f+4f+4e4e4a4a4> ]2 <\n   [ g4g4f+4f+4>c4c4<b4b4a+4a+4a4a4g+4g+4a4a4 ]2\n   q8 [ dddrrrdddrdddddr ]8 >>>\n   q3 [ ddaa>dd<aa ]24 <<\n   [\n     q8 d8d8d8d8r8<f+8f+8f+8e8e8e8e8a8a8a8a8r8f+8f+8f+8f+8f+8f+8f+8\n     q7 g6d6e6 a+6a6g6 > \n   ]4 q8 <\n   [ dddrrrdddrdddddr<a+a+a+rrra+a+>crcccccr ]3\n   [ dddrrrdddrdddddr ]2\n   d8r8r2.r4drddd8r8r16\n;\n\n\n/* ノイズ */\n#X= c+16;\n#Y= na16 c+8 na15;\n#Z= na17 a16 na15;\n#D=\n   %1 @9,63,0,0,47,0 @ph-1 v16 x128 o0 l16 q8 @q0\n   na15\n   [ XXX rrr XXX r XXXXX r ]10\n   [ X rrr Y rr ]32\n   [ X r XX X r XX X r XX Y XX ]8\n   [ X rrr ]16\n   [ X r ]64\n   [ XXY ZXY ]32\n   [ XXX rrr XXX r XXXXX r ]8\n   Yrr r1 Y XX Y rr r\n;\n\n\n/* 拡張音源 */\n#E=\n   %5 @2,63,0,0,47,0 v16 x128 o4 l16 q8 @q1 na5 @f104\n   [ a1>c1<b1a+1 ]2 a1a1 > \n   [ f+a>df+a4g4f+4d1<ef+ga>d4<a4>gf+d<ag2>d2< ]2 >\n   [ c+2d4<a4>f+4e4g4f+4e8d8<a+8g8f+4>d4<g+8b8>e4d4e4 ]2 <<\n   [ a2>c2<b2a+2 ]4 d1 r1r1r1\n   >d4.<a8d2.r4g4.f+8< d6a6>d6 f+6a6>d6 e4.<a+8g2\n   a2a4.r8 g6f+6d6 e6d6e6 d1 g6a+6>d6 g6a+6>d6 <\n   [ f+af+aabab>dedeef+ef+< ]8 <\n   [ a1>d2c+4.<b8 a1 d2g4.f+8 ]2\n   a1 c6g6>c6<d6g6>c6 d1 f6c6<g6>g6e6c6 d1 <d4a4g4>c4\n   [ eeerrreeereeeeer ]2\n   e1r4<drdd<d4&d16\n;\n\n\n/* 再生 */\nt130\n@v48 A;\n@v48 B;\n@v64 C;\n@v48 D;\n@v64 E;\n\n\n#END;\n")

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
