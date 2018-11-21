import java.util.*;
import java.util.Arrays;
import static javax.swing.JOptionPane.*;
import static java.awt.event.KeyEvent.*;


// Aqui pode ser ajustada a posição do observador.
// A posição do observador pode ser alterada com as teclas F2(+x) - F3(+y) - F4(+z) - F5(-x) - F6(-y) - F7(-z) .
  int OBS_X = 0;
  int OBS_Y = 0;
  int OBS_Z = 0;

  //Variaveis globais de rotação, translação e escalonamento.
  
  // Rotação : o angulo de rotação em cada eixo.
  float ax = 0;
  float ay = 0;
  float az = 0;
  
  // Translação: o vetor de deslocamento.
  float tx = 0;
  float ty = 0;
  float tz = 0; 
 
  // Escalonamento: o redimensionamento em cada dimensão.
  float sx = 1;
  float sy = 1;
  float sz = 1;
  
  //incremento da rotação.
  float rot_inc = 0.1;
  //incremento da translação.
  float tra_inc = 0.5;
  //incremento do escalonamento.
  float esc_inc = 0.1;

  // código da projeção escolhida.
  int escolha_projecao = 0;

Universe uni;
int index = 0;

void setup(){

	size(500,500);
	background(0,0,0);
		
	boolean test_mode = false;
	String[] filelines = loadStrings("figure.dat");
	Reader r = new Reader();
	r.read(filelines);
	uni = new Universe(r, 500);
	uni.update();	
	Painter painter = new Painter(uni, uni.cavalier);
	painter.draw(50,100,100);
		
	if(test_mode == true){
		print("STARTING TESTS. \n");
		r.testvalues();
		ArrayList<String> testlines = r.test_array; 
//		print(String.join("\n", testlines)); // uncomment to print testlines
		for(int i = 0; i < filelines.length; i++){
			if (filelines[i].equals(testlines.get(i)) == false ) {
				print("LINE MISMATCH: ",filelines[i]," ",testlines.get(i)," \n ");
				throw new RuntimeException("The file was not correctly read.");
			}
		}
		print("Reader test - SUCESS \n");
		print("Update universe.\n");
		uni.update();
		for(ArrayList<ArrayList<Float>> object : uni.transformed_points){
			for(ArrayList<Float> point : object){
				print("POINT ",point.get(0)," ",point.get(1)," ",point.get(2),"\n");
			}
		}
		print("Universe update - SUCESS \n");
	}

}

void draw(){
	
	background(0,0,0);

	if(keyPressed) {
		switch(key) {
		case CODED:
			if(keyCode == VK_F2)
				OBS_X += 10;
			if(keyCode == VK_F3)
				OBS_Y += 10;
			if(keyCode == VK_F4)
				OBS_Z += 10;
			if(keyCode == VK_F5)
				OBS_X -= 10;
			if(keyCode == VK_F6)
				OBS_Y -= 10;
			if(keyCode == VK_F7)
				OBS_Z -= 10;
		}
	}

	textAlign(CENTER, BOTTOM);
	String pos = "( " + Integer.toString(OBS_X) + " , " + Integer.toString(OBS_Y) + " , " + Integer.toString(OBS_Z) + ")";
	text(pos, 250, 500);
	
  	//texto de ajuda.

	String[] ajuda = loadStrings("comandos.txt");

	ArrayList<ArrayList<ArrayList<Integer>>> lines = 
		new ArrayList<ArrayList<ArrayList<Integer>>>(uni.lines);		
	int i = 0;
	int j = 0;

	float[] options = uni.get(index);
	
	// Verificar figura atual.
	if(keyPressed) {
		switch(key) {
			case CODED:
			      if(keyCode == SHIFT){
			     	index -= 1;
				if(index < 0){
					index = uni.names.size() - 1;
					if(index < 0) index = 0;
					}
	      	        	}
			      break;
		      
		            case TAB:
				index += 1;
				if(index >= uni.names.size() ){
					index = 0;
				}
			    break;
		}
	}

	options = uni.get(index);

	ax = options[0];
	ay = options[1];
	az = options[2];
	sx = options[3];
	sy = options[4];
	sz = options[5];
	tx = options[6];
	ty = options[7];
	tz = options[8];

	// Receber comando do usuário.
	if(keyPressed){	
		    //Mensagem de ajuda.
		    switch(key){
		    // +y
		    case CODED:
		      if(keyCode == VK_F1){
		        showMessageDialog(null, ajuda);
		      }
			break;
		    // Mudar de projeção com a tecla P.
		    case 'p':
		      escolha_projecao += 1;
		      break;
		    
		    // WASD + QE - rotações.
		    case 'w':
		      ay += rot_inc;
		      break;
		    // -x
		    case 'a':
		      ax -= rot_inc;
		      break;
		    // -y
		    case 's':
		      ay -= rot_inc;
		      break;
		    // +x
		    case 'd':
		      ax += rot_inc;
		      break;
		    // -z
		    case 'q':
		      az -= rot_inc;
		      break;
		    // +z
		    case 'e':
		      az += rot_inc;
		      break;
		    
		    // TFGH + RY - translações.
		    // +y
		    case 't':
		      ty += tra_inc;
		      break;
		    // -x
		    case 'f':
		      tx -= tra_inc;
		      break;
		    // -y
		    case 'g':
		      ty -= tra_inc;
		      break;
		    // +x
		    case 'h':
		      tx += tra_inc;
		      break;
		    // -z
		    case 'r':
		      tz -= tra_inc;
		      break;
		    // +z
		    case 'y':
		      tz += tra_inc;
		      break;
		    
		    // IJKL + UO + VB - escalonamento.
		    //+y
		    case 'i':
		      sy += esc_inc;
		      break;
		    //-x
		    case 'j':
		    sx -= esc_inc;
		      break;
		    //-y
		    case 'k':
		    sy -= esc_inc;
		      break;
		    //+x
		    case 'l':
		    sx += esc_inc;
		      break;
		    //-z
		    case 'u':
		    sz -= esc_inc;
		      break;
		    //+z
		    case 'o':
		    sz += esc_inc;
		      break;
		   // todas as dimensões - aumentar
		   case 'v':
		     sx += esc_inc;
		     sy += esc_inc;
		     sz += esc_inc;
		     break;
		  case 'b':
		   // todas as dimensões - diminuir
		     sx -= esc_inc;
		     sy -= esc_inc;
		     sz -= esc_inc;
		     break;
		     
		  //restaurar condições iniciais
		  case 'n':
		    ax = 0;
		    ay = 0;
		    az = 0;
		    tx = 0;
		    ty = 0;
		    tz = 0;
		    sx = 1;
		    sy = 1;
		    sz = 1;
		    rot_inc = 0.1;
		    tra_inc = 0.1;
		    esc_inc = 0.1;
		    break;
		  //aumentar intensidade da rotação
		  case '2':
		    rot_inc += 0.1;
		    break;
		  //diminuir intensidade da rotação
		  case '1':
		    rot_inc -= 0.1;
		    break;
		  //aumentar intensidade da translação
		  case '4':
		    tra_inc += 0.1;
		    break;
		  //diminuir intensidade da translação
		  case '3':
		    tra_inc -= 0.1;
		    break;
		  //aumentar intensidade do escalonamento
		  case '6':
		    esc_inc += 0.1;
		    break;
		  //diminuir intensidade do escalonamento
		  case '5':
		    esc_inc -= 0.1;
		    break;
		  }
	}

	options[0] = ax;
	options[1] = ay;
	options[2] = az;
	options[3] = sx;
	options[4] = sy;
	options[5] = sz;
	options[6] = tx;
	options[7] = ty;
	options[8] = tz;

	
	// Atualizar figura com comando do usuário.
	uni.set(options, index);

	uni.update();

	  //obter coordenadas na projeção escolhida
	  
	  String projecao = " ";
	  escolha_projecao %= 5;
	  switch(escolha_projecao){
	    case 0:
	      projecao = "Projeção Paralela Oblíqua Cavaleira";
	      break;
	   case 1:
	     projecao = "Projeção Paralela Oblíqua Cabinet";
	     break;
	   case 2:
	     projecao = "Projeção Paralela Ortográfica Isométrica";
	     break;
	   case 3:
	     projecao = "Projeção Perspectiva com um ponto de fuga";
	     break;
	   case 4:
	     projecao = "Projeção Perspectiva com dois pontos de fuga";
	     break;
	  }
	  
	  textAlign(RIGHT);
	  text(projecao,350,20);


	//Desenho do preenchimento
	
	Painter paint = new Painter(uni, uni.cavalier);
	switch(escolha_projecao){
		case 0:
			paint = new Painter(uni, uni.cavalier);
			break;
		case 1:
			paint = new Painter(uni, uni.cabinet);
			break;
		case 2:
			paint = new Painter(uni, uni.isometric);
			break;
		case 3:
			paint = new Painter(uni, uni.perspective1);
			break;
		case 4:
			paint = new Painter(uni, uni.perspective2);
			break;
	}
	
	paint.draw(OBS_X,OBS_Y,OBS_Z);
	
	for(ArrayList<Float> line : paint.result){
		float x0 = line.get(0);
		float y0 = line.get(1);
		float x1 = line.get(2);
		float y1 = line.get(3);
		int r = Math.round(255 * line.get(4) );
		int g = Math.round(255 * line.get(5) );
		int b = Math.round(255 * line.get(6) );
		color current_color = color(r,g,b);

		stroke(current_color);
		line(x0,y0,x1,y1);
	
//			//Algoritmo de desenho de linhas de Bresenham
//			int x0_int = Math.round(x0);
//			int y0_int = Math.round(y0);
//			int x1_int = Math.round(x1);
//			int y1_int = Math.round(y1);
//			int dx = Math.round(x1 - x0);
//			int dy = Math.round(y1 - y0);
//			int p1 = 0;
//			int p2 = 0;
//			int p3 = 0;
//			int p4 = 0;
//			int s = 0;
//			int d = 0;
//			int current_x = 0;
//			int current_y = 0;
//			if(abs(dy) < abs(dx)){
//				if(x0_int > x1_int){
//					p1 = x1_int;
//					p2 = y1_int;
//					p3 = x0_int;
//					p4 = y0_int;	
//				}
//				else{
//					p1 = x0_int;
//					p2 = y0_int;
//					p3 = x1_int;
//					p4 = y1_int;
//				}
//				dx = p3 - p1;
//				dy = p4 - p2;
//				s = 1;
//				if( dy < 0 ){
//					s = -1;
//					dy = -dy;
//				}
//				d = 2*dy - dx;
//				current_y = p2;
//				for(current_x = p1; current_x <= p3; current_x++){
//					set(current_x,current_y,current_color);
//					if(d > 0){
//						current_y += s;
//						d -= 2 * dx;
//					}
//					d += 2 * dy;
//				}
//			}
//			else{
//				if(y0_int > y1_int){
//					p1 = x1_int;
//					p2 = y1_int;
//					p3 = x0_int;
//					p4 = y0_int;
//				}
//				else{
//					p1 = x0_int;
//					p2 = y0_int;
//					p3 = x1_int;
//					p4 = y1_int;
//				}
//				dx = p3 - p1;
//				dy = p4 - p2;
//				s = 1;
//				if( dx < 0){
//					s = -1;
//					dx = -dx;
//				}
//				d = 2*dx - dy;
//				current_x = p1;
//				for(current_y = p2; current_y <= p4; current_y++){
//					set(current_x,current_y,current_color);
//					if(d > 0){
//						current_x += s;
//						d -= 2 * dy;
//					}
//					d += 2 * dx;
//				}
//			}


	}

	// Desenho das arestas
	color white = color(255,255,255);
	color red = color(255,0,0);
	color current_color;
	i = 0;
	j = 0;
	for(ArrayList<ArrayList<Integer>> object : uni.lines ){
		if(index == i) current_color = red;
		else current_color = white;
		for(ArrayList<Integer> pair : object){
			int a = pair.get(0);
			int b = pair.get(1);
			float x0 = 0.0;
			float y0 = 0.0;
			float x1 = 0.0;
			float y1 = 0.0;
			switch(escolha_projecao) {
				case 0:	
					x0 = uni.cavalier.get(i).get(a).get(0);
					y0 = uni.cavalier.get(i).get(a).get(1);
					x1 = uni.cavalier.get(i).get(b).get(0);
					y1 = uni.cavalier.get(i).get(b).get(1);
					break;
				case 1:	
					x0 = uni.cabinet.get(i).get(a).get(0);
					y0 = uni.cabinet.get(i).get(a).get(1);
					x1 = uni.cabinet.get(i).get(b).get(0);
					y1 = uni.cabinet.get(i).get(b).get(1);
					break;
				case 2:	
					x0 = uni.isometric.get(i).get(a).get(0);
					y0 = uni.isometric.get(i).get(a).get(1);
					x1 = uni.isometric.get(i).get(b).get(0);
					y1 = uni.isometric.get(i).get(b).get(1);
					break;
				case 3:	
					x0 = uni.perspective1.get(i).get(a).get(0);
					y0 = uni.perspective1.get(i).get(a).get(1);
					x1 = uni.perspective1.get(i).get(b).get(0);
					y1 = uni.perspective1.get(i).get(b).get(1);
					break;
				case 4:	
					x0 = uni.perspective2.get(i).get(a).get(0);
					y0 = uni.perspective2.get(i).get(a).get(1);
					x1 = uni.perspective2.get(i).get(b).get(0);
					y1 = uni.perspective2.get(i).get(b).get(1);
					break;
			}
			stroke(current_color);
			line(x0,y0,x1,y1);

			//Algoritmo de desenho de linhas de Bresenham
//			int x0_int = Math.round(x0);
//			int y0_int = Math.round(y0);
//			int x1_int = Math.round(x1);
//			int y1_int = Math.round(y1);
//			int dx = Math.round(x1 - x0);
//			int dy = Math.round(y1 - y0);
//			int p1 = 0;
//			int p2 = 0;
//			int p3 = 0;
//			int p4 = 0;
//			int s = 0;
//			int d = 0;
//			int current_x = 0;
//			int current_y = 0;
//			if(abs(dy) < abs(dx)){
//				if(x0_int > x1_int){
//					p1 = x1_int;
//					p2 = y1_int;
//					p3 = x0_int;
//					p4 = y0_int;	
//				}
//				else{
//					p1 = x0_int;
//					p2 = y0_int;
//					p3 = x1_int;
//					p4 = y1_int;
//				}
//				dx = p3 - p1;
//				dy = p4 - p2;
//				s = 1;
//				if( dy < 0 ){
//					s = -1;
//					dy = -dy;
//				}
//				d = 2*dy - dx;
//				current_y = p2;
//				for(current_x = p1; current_x <= p3; current_x++){
//					set(current_x,current_y,current_color);
//					if(d > 0){
//						current_y += s;
//						d -= 2 * dx;
//					}
//					d += 2 * dy;
//				}
//			}
//			else{
//				if(y0_int > y1_int){
//					p1 = x1_int;
//					p2 = y1_int;
//					p3 = x0_int;
//					p4 = y0_int;
//				}
//				else{
//					p1 = x0_int;
//					p2 = y0_int;
//					p3 = x1_int;
//					p4 = y1_int;
//				}
//				dx = p3 - p1;
//				dy = p4 - p2;
//				s = 1;
//				if( dx < 0){
//					s = -1;
//					dx = -dx;
//				}
//				d = 2*dx - dy;
//				current_x = p1;
//				for(current_y = p2; current_y <= p4; current_y++){
//					set(current_x,current_y,current_color);
//					if(d > 0){
//						current_x += s;
//						d -= 2 * dy;
//					}
//					d += 2 * dx;
//				}
//			}

			j += 1;
		}
		i += 1;
	}


}
