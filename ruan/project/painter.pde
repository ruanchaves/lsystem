import java.util.*;
import java.util.Arrays;
import java.util.Collections;

class Painter {

	ArrayList<ArrayList<ArrayList<Integer>>> lines;
	ArrayList<ArrayList<ArrayList<Integer>>> facepoints;
	ArrayList<ArrayList<ArrayList<Float>>> facecolors;
	ArrayList<ArrayList<ArrayList<Float>>> transformed_points;
	ArrayList<ArrayList<ArrayList<Float>>> projection;


	ArrayList<Integer> selected_object;
	ArrayList<Integer> face_id;
	ArrayList<ArrayList<ArrayList<ArrayList<Float>>>> face_coord;
	ArrayList<ArrayList<ArrayList<Float>>> scan_coord;

	ArrayList<ArrayList<Float>> result;
		

	Painter(Universe uni , ArrayList<ArrayList<ArrayList<Float>>> projection){
		
		this.lines = new ArrayList<ArrayList<ArrayList<Integer>>>(uni.lines);

		this.facepoints = new ArrayList<ArrayList<ArrayList<Integer>>>(uni.facepoints);
		
		this.transformed_points = new ArrayList<ArrayList<ArrayList<Float>>>(uni.transformed_points);
		
		this.projection = new ArrayList<ArrayList<ArrayList<Float>>>(projection);
		
		this.facecolors = new ArrayList<ArrayList<ArrayList<Float>>>(uni.facecolors);
		
	}

	public void draw(int observador_x, int observador_y, int observador_z){
		
//		//Criar um vetor para enumerar as faces.
		int i = 0;
		ArrayList<ArrayList<Integer>> face_enum = new ArrayList<ArrayList<Integer>>();
		for(ArrayList<ArrayList<Integer>> object : this.facepoints){
			int j = 0;
			ArrayList<Integer> object_enum = new ArrayList<Integer>();
			for(ArrayList<Integer> face : object){
				object_enum.add(j);
//				print(j," "); //DEBUG
				j += 1;
			}
			face_enum.add(object_enum);
//			print("\n"); //DEBUG
			i += 1;
		}

//		//Criar um vetor booleano para dizer se a face é visível ou não.
//
		i = 0;
		ArrayList<ArrayList<Boolean>> face_bool = new ArrayList<ArrayList<Boolean>>();
		for(ArrayList<ArrayList<Integer>> object : this.facepoints ){
			int j = 0;
			ArrayList<Boolean> object_bool = new ArrayList<Boolean>();
			for(ArrayList<Integer> faces : object ){
				int a = faces.get(0);
				int b = faces.get(1);
				int c = faces.get(2);
				float ax = this.transformed_points.get(i).get(a).get(0);
				float ay = this.transformed_points.get(i).get(a).get(1);
				float az = this.transformed_points.get(i).get(a).get(2);
				float bx = this.transformed_points.get(i).get(b).get(0);
				float by = this.transformed_points.get(i).get(b).get(1);
				float bz = this.transformed_points.get(i).get(b).get(2);
				float cx = this.transformed_points.get(i).get(c).get(0);
				float cy = this.transformed_points.get(i).get(c).get(1);
				float cz = this.transformed_points.get(i).get(c).get(2);
				
				float nx = ( cy - by ) * ( az - bz ) - ( ay - by  ) * ( cz - bz );
				float ny = ( cz - bz ) * ( cx - bx ) - ( az - bz  ) * ( cx - bx );
				float nz = ( cx - bx ) * ( ay - by ) - ( ax - bx  ) * ( cy - by );
				float nl = nx * ( observador_x - bx ) + ny * ( observador_y - by ) + nz * ( observador_z - bz );
				if(nl > 0){
					object_bool.add(true);
//					print(true," "); //DEBUG
				}
				else{
					object_bool.add(false);
//					print(false," "); //DEBUG
				}  
				j += 1;
			}
			i += 1;
			face_bool.add(object_bool);
//			print(" \n "); //DEBUG
		}
//
//		//Criar um vetor com o z médio de cada face.
		ArrayList<ArrayList<Float>> average_z = new ArrayList<ArrayList<Float>>();
		i = 0;
		for(ArrayList<ArrayList<Integer>> object : this.facepoints ){
			int j = 0;
			ArrayList<Float> object_averages = new ArrayList<Float>();
			for(ArrayList<Integer> face : object ){
				int k = 0;
				float average_value = 0;
				for(Integer point : face ){
					
					float point_z = this.transformed_points.get(i).get(point).get(2);
					average_value += point_z;
					k += 1;	
				}
				average_value /= k;
				object_averages.add(average_value);
//				print(average_value," "); //DEBUG
				j += 1;	
			}
			average_z.add(object_averages);
//			print(" \n "); //DEBUG
			i += 1;
		}

	//Unir os três arrays sem diferenciar entre objetos,
	//Criando a seguinte tabela:
	// || z médio || booleano ( visível / invisível ) || ID da face || ID do objeto ||
	ArrayList<ArrayList<Float>> face_table = new ArrayList<ArrayList<Float>>();
	i = 0;
	for(ArrayList<Float> object : average_z ){
		int j = 0;
		for( Float value : object ){
			ArrayList<Float> table_buffer = new ArrayList<Float>();
			float a = average_z.get(i).get(j);
			float b = face_bool.get(i).get(j) ? 1.0 : 0.0;
			float c = (float)(face_enum.get(i).get(j));
			table_buffer.add(a);
			table_buffer.add(b);
			table_buffer.add(c);
			table_buffer.add((float)(i));
			j += 1;
//			print("[ ",a," ",b," ",c," ",i," ] \n"); //DEBUG
			face_table.add(table_buffer);
		}
//		print(" \n === \n "); //DEBUG
		i += 1;
	}

//	Ordenar a tabela
	Collections.sort(face_table, new Comparator<ArrayList<Float>>() {
			@Override
			public int compare(ArrayList<Float> o1, ArrayList<Float> o2){
				return o1.get(0).compareTo(o2.get(0));
			}
		});

//	DEBUG	
//	for(ArrayList<Float> line : face_table ){  
//		print(line.get(0)," ",line.get(1)," ",line.get(2)," ",line.get(3)," \n");
//	}  

			
//	 Devemos entregar ao algoritmo de varredura uma lista de arestas para cada face.
//
//

//	Para cada face que vai ser desenhada, capturar os índices dos pontos da face.	
	ArrayList<ArrayList<Integer>> selected_facepoints = 
		new ArrayList<ArrayList<Integer>>();

//	Identificar de qual objeto veio cada face selecionada.

	ArrayList<Integer> selected_object = new ArrayList<Integer>();

//	Identificar qual o ID no objeto de cada face selecionada.

	ArrayList<Integer> face_id = new ArrayList<Integer>();

// 	Iniciar captura.		
	for(ArrayList<Float> line : face_table ){ 
		float avg_z = line.get(0);
		float table_bool = line.get(1);
		float f_enum = line.get(2);
		float o_enum = line.get(3);
		
		if(table_bool == 1){
			selected_object.add(Math.round(o_enum));
			face_id.add(Math.round(f_enum));
			
			ArrayList<Integer> face_points = this.facepoints.get(Math.round(o_enum)).get(Math.round(f_enum));

			selected_facepoints.add(face_points);
		}
	}

//	DEBUG
//	for(ArrayList<Integer> face : selected_facepoints){
//		for(Integer point: face){
//			print(point," ");
//		}
//		print(" \n ");
//	}
//	print("\n === \n ");
//	for(Integer point : selected_object){
//		print(point," ");
//	}
//	print(" \n ");

//
//

//	Para cada face selecionada, capturar todas as suas arestas.



	ArrayList<ArrayList<ArrayList<Integer>>> face_edges =
		new ArrayList<ArrayList<ArrayList<Integer>>>();

	int j = 0;
	for(ArrayList<Integer> face : selected_facepoints ){

			ArrayList<ArrayList<Integer>> edge_buffer = 
				new ArrayList<ArrayList<Integer>>();

			i = selected_object.get(j);
			ArrayList<ArrayList<Integer>> object_lines = this.lines.get(i);
			for(int k = 0; k < object_lines.size(); k++ ){
				ArrayList<Integer> edge = object_lines.get(k);
				int a = object_lines.get(k).get(0);
				int b = object_lines.get(k).get(1);
				if( face.contains(a) && face.contains(b) ){
					edge_buffer.add(edge);
				}
			}	
			face_edges.add(edge_buffer);
			j += 1;
		}

// DEBUG
//	for(ArrayList<ArrayList<Integer>> face : face_edges){
//		for(ArrayList<Integer> edge : face){
//			print("[ ",edge.get(0)," ",edge.get(1)," ] , ");
//		}
//		print(" \n ");
//	}

//	Os índices são substituidos pelas coordenadas x,y da projeção.
//
	ArrayList<ArrayList<ArrayList<ArrayList<Float>>>> face_coord =
		new ArrayList<ArrayList<ArrayList<ArrayList<Float>>>>();

	i = 0;
	for(ArrayList<ArrayList<Integer>> face : face_edges){

		ArrayList<ArrayList<ArrayList<Float>>> face_buffer =
			new ArrayList<ArrayList<ArrayList<Float>>>();
	
		j = 0;
		for(ArrayList<Integer> edge : face){
			ArrayList<ArrayList<Float>> edge_buffer = 
				new ArrayList<ArrayList<Float>>();
			int object_index = selected_object.get(i);
			int a = edge.get(0);
			int b = edge.get(1);
			
			ArrayList<Float> point_a = this.projection.get(object_index).get(a);
			ArrayList<Float> point_b = this.projection.get(object_index).get(b);
			
			edge_buffer.add(point_a);
			edge_buffer.add(point_b);
			face_buffer.add(edge_buffer);
		
			j += 1;
		}
		face_coord.add(face_buffer);
		i += 1;
	}
	
// DEBUG
	for(ArrayList<ArrayList<ArrayList<Float>>> face : face_coord){
		for(ArrayList<ArrayList<Float>> edge_pair : face){
			for(ArrayList<Float> edge : edge_pair){
				print("[ ",edge.get(0)," ",edge.get(1)," ",edge.get(2)," ] , ");
			}
		print(" || ");
	}
	print(" *** \n ");
}


//	Agora alimentamos algoritmo ScanLine com face_coord e receberemos de volta uma lista de linhas a 
//	serem pintadas em cada face ( scan_coord ).

	this.face_coord = new ArrayList<ArrayList<ArrayList<ArrayList<Float>>>>(face_coord);
	this.selected_object = new ArrayList<Integer>(selected_object);
	this.face_id = new ArrayList<Integer>(face_id);
	scanline();

// 	Após a execução do ScanLine, nos preparamos para retornar uma saída com linhas do tipo (x0, y0, x1, y1, r, g, b) .
	
	ArrayList<ArrayList<Float>> result = new ArrayList<ArrayList<Float>>();
	
	i = 0;
	for(ArrayList<ArrayList<Float>> face : this.scan_coord ){
		j = 0;
		for( ArrayList<Float> edge : face ){
			
			ArrayList<Float> line_buffer = new ArrayList<Float>();
			float x0 = edge.get(0);
			float y0 = edge.get(1);
			float x1 = edge.get(2);
			float y1 = edge.get(3);
			float r = this.facecolors.get( selected_object.get(i) ).get( face_id.get(i) ).get(0);
			float g = this.facecolors.get( selected_object.get(i) ).get( face_id.get(i) ).get(1);
			float b = this.facecolors.get( selected_object.get(i) ).get( face_id.get(i) ).get(2);
			line_buffer.add(x0);
			line_buffer.add(y0);
			line_buffer.add(x1);
			line_buffer.add(y1);
			line_buffer.add(r);
			line_buffer.add(g);
			line_buffer.add(b);			
			result.add(line_buffer);
			j += 1;	
		}
		i += 1;
	}

	this.result = new ArrayList<ArrayList<Float>>(result);

	}
	//draw()

	public void scanline(){

		ArrayList<ArrayList<ArrayList<Float>>> scan_coord = 
			new ArrayList<ArrayList<ArrayList<Float>>>();

		for( ArrayList<ArrayList<ArrayList<Float>>> face : face_coord ){

			ArrayList<ArrayList<Float>> face_buffer = 
				new ArrayList<ArrayList<Float>>();


			ArrayList<ArrayList<Float>> all_table = 
				new ArrayList<ArrayList<Float>>();

			ArrayList<ArrayList<Float>> global_table = 
				new ArrayList<ArrayList<Float>>();

			ArrayList<ArrayList<Float>> active_table = 
				new ArrayList<ArrayList<Float>>(); 


			// geração de todas as linhas de tabela possíveis 

			for( ArrayList<ArrayList<Float>> edge : face ){

				ArrayList<Float> table_line = new ArrayList<Float>();
			
				float xa = edge.get(0).get(0); 
				float ya = edge.get(0).get(1);
				float xb = edge.get(1).get(0);
				float yb = edge.get(1).get(1);
			
				float ymin = Math.min(ya,yb);
				float x_to_ymin = 0.0;
				if( ymin == ya ){
					x_to_ymin = xa;
				}
				else{
					x_to_ymin = xb;
				}
				float ymax = Math.max(ya,yb);
				float xmin = Math.min(xa,xb);
				float xmax = Math.max(xa,xb);
			
				if( ymax - ymin != 0.0 && xmax - xmin != 0.0 ) {
					float m = ( ymax - ymin ) / ( xmax - xmin );
					
					float minv = 1.0 / m;
					
					table_line.add(ymin); //0
					
					table_line.add(ymax); //1
				
					table_line.add(x_to_ymin); //2
				
					table_line.add(minv); //3
	
					all_table.add(table_line);
				}

			}
				
				if(all_table.size() == 0) {
					continue;
				}

				// Montagem da tabela global

				global_table.add(all_table.get(0));
				
				for(int j = 1; j < all_table.size(); j++ ) {
					int i = 0;
					while(true) {
	
						int start = i;
						
						ArrayList<Float> current_line = all_table.get(j);
						float line_ymin = current_line.get(0);
						float pos_ymin = global_table.get(i).get(0);
						float line_xmin = current_line.get(2);
						float pos_xmin = global_table.get(i).get(2);
						if(line_ymin > pos_ymin) {
							i += 1;
						}
						if(line_ymin <= pos_ymin) {
							if(line_xmin > pos_xmin){
								i += 1;
							}
						}
						if(i == global_table.size() ){
							global_table.add(current_line);
							break;
						}
	
						if(start == i){
							global_table.add(i, current_line);
							break;
						}
					}
				}

				// Inicialização da scanline

				float scanline = global_table.get(0).get(0);

				// Montagem da tabela ativa
		
				for(ArrayList<Float> line : global_table) {
					if(Math.round(line.get(0)) == Math.round(scanline)){
						active_table.add(line);
					}
				}



				while( active_table.size() != 0 ){

					// Adição das linhas a serem desenhadas ao array de saída do algoritmo
					for(int i = 0; i < active_table.size(); i = i + 2){
						if( i + 1 < active_table.size() ){
							ArrayList<Float> line = new ArrayList<Float>();
							line.add(active_table.get(i).get(2)); // x0
							line.add(scanline); //y0
							line.add(active_table.get(i+1).get(2)); // x1
							line.add(scanline); //y1
							face_buffer.add(line);
						}
					}
	
					// Remover linhas com y == scanline + 1
					scanline += 1;
					Iterator itr = active_table.iterator();
					while(itr.hasNext()) {
						ArrayList<Float> x = (ArrayList<Float>)(itr.next());
						if( Math.round(x.get(1)) == Math.round(scanline) ){
							itr.remove();
						}
					
					}

					// Incrementar x em toda tabela ativa
					for(ArrayList<Float> line : active_table){
						float minv = line.get(3);
						float x = line.get(2);
						line.set(2, minv + x);
					}
					
					// Remover toda linha com y == scanline da tabela global e colocar na ativa
					itr = global_table.iterator();
					while(itr.hasNext()){
						ArrayList<Float> x = (ArrayList<Float>)(itr.next());
						if( Math.round(x.get(0)) == Math.round(scanline) ){
							active_table.add(x);
							itr.remove();
						}
					}

					
					//	Ordenar a tabela ativa na ordem crescente dos valores de x
						Collections.sort(active_table, new Comparator<ArrayList<Float>>() {
								@Override
								public int compare(ArrayList<Float> o1, ArrayList<Float> o2){
									return o1.get(2).compareTo(o2.get(2));
								}
							});
						
						
					}
					//while		
				
				
			
			scan_coord.add(face_buffer);	
		}
		//for face : face_coord
		
		this.scan_coord = new ArrayList<ArrayList<ArrayList<Float>>>(scan_coord);
		
		// DEBUG
		for(ArrayList<ArrayList<Float>> face : scan_coord){
			for(ArrayList<Float> line : face ){
				print(line.get(0)," ",line.get(1)," ",line.get(2)," ",line.get(3)," ");
				print(" \n ");
			}
			print("*** \n *** \n ");
		}
	}
	//scanline()

}
//Painter
