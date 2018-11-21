import java.util.*;
import java.util.Arrays;

class Universe {

	int width;
	int xmin;
	int xmax;
	int ymin;
	int ymax;


	//Cada array contém todos os objetos do universo	
	
	ArrayList<ArrayList<String>> metadata; 

	ArrayList<ArrayList<String>> names; 
	
	ArrayList<ArrayList<String>> properties;
	
	ArrayList<ArrayList<ArrayList<Float>>> points;
	
	ArrayList<ArrayList<ArrayList<Integer>>> facepoints;

	ArrayList<ArrayList<ArrayList<Float>>> facecolors;

	ArrayList<ArrayList<ArrayList<Integer>>> lines; 

	ArrayList<ArrayList<String>> faces;

	ArrayList<ArrayList<ArrayList<Float>>> rotation;
	ArrayList<ArrayList<ArrayList<Float>>> scale;
	ArrayList<ArrayList<ArrayList<Float>>> translation;

	ArrayList<ArrayList<ArrayList<Float>>> transformed_points;
	
	ArrayList<ArrayList<ArrayList<Float>>> cavalier; 
	ArrayList<ArrayList<ArrayList<Float>>> cabinet; 
	ArrayList<ArrayList<ArrayList<Float>>> isometric; 
	ArrayList<ArrayList<ArrayList<Float>>> perspective1; 
	ArrayList<ArrayList<ArrayList<Float>>> perspective2; 

	// Fornece ao usuário uma interface de comunicação com um objeto
	public float[] get(int i){
		float ax = this.rotation.get(i).get(0).get(0);
		float ay = this.rotation.get(i).get(0).get(1);
		float az = this.rotation.get(i).get(0).get(2);
		float sx = this.scale.get(i).get(0).get(0);
		float sy = this.scale.get(i).get(0).get(1);
		float sz = this.scale.get(i).get(0).get(2);
		float tx = this.translation.get(i).get(0).get(0);
		float ty = this.translation.get(i).get(0).get(1);
		float tz = this.translation.get(i).get(0).get(2);
		return new float[]{ax,ay,az,sx,sy,sz,tx,ty,tz};
	}
	
	// Recebe atualização a um objeto pelo usuário
	public void set(float[] user, int i){
		float ax = user[0];
		float ay = user[1];
		float az = user[2];
		float sx = user[3];
		float sy = user[4];
		float sz = user[5];
		float tx = user[6];
		float ty = user[7];
		float tz = user[8];
		int counter = 0;

		for(ArrayList<ArrayList<Float>> object: this.rotation){
			if(counter == i){
				for(ArrayList<Float> point: object){
					point.set(0, ax);
					point.set(1, ay);
					point.set(2, az);
				}
				break;
			}
			counter += 1;
		}
	
		counter = 0;	
		for(ArrayList<ArrayList<Float>> object: this.translation){
			if(counter == i){
				for(ArrayList<Float> point: object){
					point.set(0, tx);
					point.set(1, ty);
					point.set(2, tz);
				}
				break;
			}
			counter += 1;
		}


		counter = 0;
		for(ArrayList<ArrayList<Float>> object: this.scale){
			if(counter == i){
				for(ArrayList<Float> point: object){
					point.set(0, sx);
					point.set(1, sy);
					point.set(2, sz);
				}
				break;
			}
			counter += 1;
		}

	}
		
	
	//Atualiza o universo
	public void update(){
		this.transformed_points = new ArrayList<ArrayList<ArrayList<Float>>>();
		
		for(ArrayList<ArrayList<Float>> object : this.points){
			ArrayList<ArrayList<Float>> object_buffer = new ArrayList<ArrayList<Float>>();
			for(ArrayList<Float> point : object ){
				ArrayList<Float> point_buffer = new ArrayList<Float>();
				point_buffer.add(point.get(0));
				point_buffer.add(point.get(1));
				point_buffer.add(point.get(2));
				object_buffer.add(point_buffer);
			}
			this.transformed_points.add(object_buffer);
		}	
		
		// Rotação, translação e escalonamento
		int transformed_points_counter = 0;
		for(ArrayList<ArrayList<Float>> object : this.transformed_points ){
			for(ArrayList<Float> point : object ){
				float ax = this.rotation.get(transformed_points_counter).get(0).get(0);
				float ay = this.rotation.get(transformed_points_counter).get(0).get(1);
				float az = this.rotation.get(transformed_points_counter).get(0).get(2);
				float cos_ax = (float)(Math.cos((double)(ax)));
				float cos_ay = (float)(Math.cos((double)(ay)));
				float cos_az = (float)(Math.cos((double)(az)));
				float sin_ax = (float)(Math.sin((double)(ax)));
				float sin_ay = (float)(Math.sin((double)(ay)));
				float sin_az = (float)(Math.sin((double)(az)));
				float x = point.get(0);
				float y = point.get(1);
				float z = point.get(2);
				float new_x;
				float new_y;
				float new_z;

				x = point.get(0);
				y = point.get(1);
				z = point.get(2);

				new_x = x - xmin;
				new_y = y - ymin;
				new_z = z; 
				point.set(0, new_x);
				point.set(1, new_y);
				point.set(2, new_z);
				
				
				new_x = x * cos_ax - y * sin_ax;
				new_y = x * sin_ax + y * cos_ax;
				new_z = z;
				point.set(0, new_x);
				point.set(1, new_y);
				point.set(2, new_z);

				x = point.get(0);
				y = point.get(1);
				z = point.get(2);
				
				new_x = x;
				new_y = y * cos_ay - z * sin_ay;
				new_z = y * sin_ay + z * cos_ay;
				point.set(0, new_x);
				point.set(1, new_y);
				point.set(2, new_z);
				
				x = point.get(0);
				y = point.get(1);
				z = point.get(2);
				
				new_x = x * cos_az + z * sin_az;
				new_y = y;
				new_z = x * (-sin_az) + z * cos_az;
				point.set(0, new_x);
				point.set(1, new_y);
				point.set(2, new_z);
				
				x = point.get(0);
				y = point.get(1);
				z = point.get(2);
				
				float tx = this.translation.get(transformed_points_counter).get(0).get(0);
				float ty = this.translation.get(transformed_points_counter).get(0).get(1);
				float tz = this.translation.get(transformed_points_counter).get(0).get(2);
			
				new_x = x + tx;
				new_y = y + ty;
				new_z = z + tz;
				point.set(0, new_x);
				point.set(1, new_y);
				point.set(2, new_z);
				
				x = point.get(0);
				y = point.get(1);
				z = point.get(2);
				
				float sx = this.scale.get(transformed_points_counter).get(0).get(0);
				float sy = this.scale.get(transformed_points_counter).get(0).get(1);
				float sz = this.scale.get(transformed_points_counter).get(0).get(2);
			
				new_x = x * sx;
				new_y = y * sy;
				new_z = z * sz;
				point.set(0, new_x);
				point.set(1, new_y);
				point.set(2, new_z);


			}
			transformed_points_counter += 1;
		}
	
		int counter1;
		int counter2;
	
		// Criação das projeções

		this.cavalier = new ArrayList<ArrayList<ArrayList<Float>>>();
		
		for(ArrayList<ArrayList<Float>> object : this.transformed_points){
			ArrayList<ArrayList<Float>> object_buffer = new ArrayList<ArrayList<Float>>();
			for(ArrayList<Float> point : object ){
				ArrayList<Float> point_buffer = new ArrayList<Float>();
				point_buffer.add(point.get(0));
				point_buffer.add(point.get(1));
				point_buffer.add(point.get(2));
				object_buffer.add(point_buffer);
			}
			this.cavalier.add(object_buffer);
		}	
		
		counter1 = 0;
		for(ArrayList<ArrayList<Float>> object : this.cavalier ){
			counter2 = 0;
			for(ArrayList<Float> point : object ){
				float x_cavalier;
				float y_cavalier;
				float z_cavalier;
				
				float x = this.transformed_points.get(counter1).get(counter2).get(0);
				float y = this.transformed_points.get(counter1).get(counter2).get(1);
				float z = this.transformed_points.get(counter1).get(counter2).get(2);
				x_cavalier = x + z * ( sqrt(2)/2 );
				y_cavalier = y + z * ( sqrt(2)/2 );
				z_cavalier = 0;
			
				counter2 += 1;

				point.set(0, x_cavalier);
				point.set(1, y_cavalier);
				point.set(2, z_cavalier);

				//cavalier to screen

				float screen_x = point.get(0);
				float screen_y = point.get(1);
			
				screen_y *= -1;
				screen_x += this.width / 2;
				screen_y += this.width / 2;
				
				point.set(0,screen_x);
				point.set(1,screen_y);
			}
			counter1 += 1;
		}



		this.cabinet = new ArrayList<ArrayList<ArrayList<Float>>>();
		
		for(ArrayList<ArrayList<Float>> object : this.transformed_points){
			ArrayList<ArrayList<Float>> object_buffer = new ArrayList<ArrayList<Float>>();
			for(ArrayList<Float> point : object ){
				ArrayList<Float> point_buffer = new ArrayList<Float>();
				point_buffer.add(point.get(0));
				point_buffer.add(point.get(1));
				point_buffer.add(point.get(2));
				object_buffer.add(point_buffer);
			}
			this.cabinet.add(object_buffer);
		}	

		counter1 = 0;
		for(ArrayList<ArrayList<Float>> object : this.cabinet ){
			counter2 = 0;
			for(ArrayList<Float> point : object ){
				float x_cabinet;
				float y_cabinet;
				float z_cabinet;
				
				float x = this.transformed_points.get(counter1).get(counter2).get(0);
				float y = this.transformed_points.get(counter1).get(counter2).get(1);
				float z = this.transformed_points.get(counter1).get(counter2).get(2);
				x_cabinet = x + z * ( sqrt(2)/4 );
				y_cabinet = y + z * ( sqrt(2)/4 );
				z_cabinet = 0;
				
				counter2 += 1;

				point.set(0, x_cabinet);
				point.set(1, y_cabinet);
				point.set(2, z_cabinet);

				//cabinet to screen

				float screen_x = point.get(0);
				float screen_y = point.get(1);
			
				screen_y *= -1;
				screen_x += this.width / 2;
				screen_y += this.width / 2;
				
				point.set(0,screen_x);
				point.set(1,screen_y);
			}
			counter1 += 1;
		}

		this.isometric = new ArrayList<ArrayList<ArrayList<Float>>>();
		
		for(ArrayList<ArrayList<Float>> object : this.transformed_points){
			ArrayList<ArrayList<Float>> object_buffer = new ArrayList<ArrayList<Float>>();
			for(ArrayList<Float> point : object ){
				ArrayList<Float> point_buffer = new ArrayList<Float>();
				point_buffer.add(point.get(0));
				point_buffer.add(point.get(1));
				point_buffer.add(point.get(2));
				object_buffer.add(point_buffer);
			}
			this.isometric.add(object_buffer);
		}	



		counter1 = 0;
		for(ArrayList<ArrayList<Float>> object : this.isometric ){
			counter2 = 0;
			for(ArrayList<Float> point : object ){
				float x_isometric;
				float y_isometric;
				float z_isometric;
				
				float x = this.transformed_points.get(counter1).get(counter2).get(0);
				float y = this.transformed_points.get(counter1).get(counter2).get(1);
				float z = this.transformed_points.get(counter1).get(counter2).get(2);
				x_isometric = 1/sqrt(6) * ( sqrt(3) * x + y + sqrt(2) * z);
				y_isometric = 1/sqrt(6) * ( 2 * y - sqrt(2) * z);
				z_isometric = 0;
				
				counter2 += 1;

				point.set(0, x_isometric);
				point.set(1, y_isometric);
				point.set(2, z_isometric);

				//isometric to screen

				float screen_x = point.get(0);
				float screen_y = point.get(1);
			
				screen_y *= -1;
				screen_x += this.width / 2;
				screen_y += this.width / 2;
				
				point.set(0,screen_x);
				point.set(1,screen_y);
			}
			counter1 += 1;
		}


		this.perspective1 = new ArrayList<ArrayList<ArrayList<Float>>>();
		
		for(ArrayList<ArrayList<Float>> object : this.transformed_points){
			ArrayList<ArrayList<Float>> object_buffer = new ArrayList<ArrayList<Float>>();
			for(ArrayList<Float> point : object ){
				ArrayList<Float> point_buffer = new ArrayList<Float>();
				point_buffer.add(point.get(0));
				point_buffer.add(point.get(1));
				point_buffer.add(point.get(2));
				object_buffer.add(point_buffer);
			}
			this.perspective1.add(object_buffer);
		}	


		counter1 = 0;
		for(ArrayList<ArrayList<Float>> object : this.perspective1 ){
			counter2 = 0;
			for(ArrayList<Float> point : object ){
				float x_perspective1;
				float y_perspective1;
				float z_perspective1;
				
				float x = this.transformed_points.get(counter1).get(counter2).get(0);
				float y = this.transformed_points.get(counter1).get(counter2).get(1);
				float z = this.transformed_points.get(counter1).get(counter2).get(2);
				x_perspective1 = x / ( 1.0 - 1.0/100.0 );
				y_perspective1 = y / ( 1.0 - 1.0/100.0 );
				z_perspective1 = 0;
				
				counter2 += 1;

				point.set(0, x_perspective1);
				point.set(1, y_perspective1);
				point.set(2, z_perspective1);

				//perspective1 to screen

				float screen_x = point.get(0);
				float screen_y = point.get(1);
			
				screen_y *= -1;
				screen_x += this.width / 2;
				screen_y += this.width / 2;
				
				point.set(0,screen_x);
				point.set(1,screen_y);
			}
			counter1 += 1;
		}


		this.perspective2 = new ArrayList<ArrayList<ArrayList<Float>>>();
		
		for(ArrayList<ArrayList<Float>> object : this.transformed_points){
			ArrayList<ArrayList<Float>> object_buffer = new ArrayList<ArrayList<Float>>();
			for(ArrayList<Float> point : object ){
				ArrayList<Float> point_buffer = new ArrayList<Float>();
				point_buffer.add(point.get(0));
				point_buffer.add(point.get(1));
				point_buffer.add(point.get(2));
				object_buffer.add(point_buffer);
			}
			this.perspective2.add(object_buffer);
		}	

		counter1 = 0;
		for(ArrayList<ArrayList<Float>> object : this.perspective2 ){
			counter2 = 0;
			for(ArrayList<Float> point : object ){
				float x_perspective2;
				float y_perspective2;
				float z_perspective2;
				
				float x = this.transformed_points.get(counter1).get(counter2).get(0);
				float y = this.transformed_points.get(counter1).get(counter2).get(1);
				float z = this.transformed_points.get(counter1).get(counter2).get(2);
				x_perspective2 = x / ( 1.0 - 1.0/100.0 - 1.0/50.0 );
				y_perspective2 = y / ( 1.0 - 1.0/100.0 - 1.0/50.0 );
				z_perspective2 = 0;
				
				counter2 += 1;

				point.set(0, x_perspective2);
				point.set(1, y_perspective2);
				point.set(2, z_perspective2);

				//perspective2 to screen

				float screen_x = point.get(0);
				float screen_y = point.get(1);
			
				screen_y *= -1;
				screen_x += this.width / 2;
				screen_y += this.width / 2;
				
				point.set(0,screen_x);
				point.set(1,screen_y);
			}
			counter1 += 1;
		}


	}

	//Convertendo os arrays lidos pelo Reader em arrays manipuláveis como objetos geométricos
	Universe(Reader r, int width){

		this.width = width;
	
		this.metadata = 
			new ArrayList<ArrayList<String>>(r.metadata);
		
		String metastring = this.metadata.get(0).get(1);
		ArrayList<Integer> property_point = new ArrayList<Integer>();
		for(String field: metastring.split(" ")){
			property_point.add(Integer.parseInt(field));
		}
		
		this.xmin = property_point.get(0);
		this.xmax = property_point.get(1);
		this.ymin = property_point.get(2);
		this.ymax = property_point.get(3);
	
		this.names = 
			new ArrayList<ArrayList<String>>(r.names);
		
		this.properties =
			new ArrayList<ArrayList<String>>(r.properties);


		ArrayList<ArrayList<String>> points =
			new ArrayList<ArrayList<String>>(r.points);

		ArrayList<ArrayList<ArrayList<Float>>> float_points =
			new ArrayList<ArrayList<ArrayList<Float>>>();
		
		for(int i = 0; i < points.size(); i++){
			ArrayList<ArrayList<Float>> new_object = new ArrayList<ArrayList<Float>>();
			for(int j = 0; j < points.get(i).size(); j++){
				ArrayList<Float> new_point = new ArrayList<Float>();
				for(String field: points.get(i).get(j).split(" ")){
					new_point.add(Float.parseFloat(field));
				}
				new_object.add(new_point);
			}
			float_points.add(new_object);
		}
		this.points = new ArrayList<ArrayList<ArrayList<Float>>>(float_points);


		ArrayList<ArrayList<String>> lines = 
			new ArrayList<ArrayList<String>>(r.lines);
		
		ArrayList<ArrayList<ArrayList<Integer>>> line_points =
			new ArrayList<ArrayList<ArrayList<Integer>>>();

		for(int i = 0; i < lines.size(); i++){
			ArrayList<ArrayList<Integer>> line_object = new ArrayList<ArrayList<Integer>>();
			for(int j = 0; j < lines.get(i).size(); j++){
				ArrayList<Integer> line_point = new ArrayList<Integer>();
				for(String field: lines.get(i).get(j).split(" ")){
					line_point.add(Integer.parseInt(field) - 1);
				}
				line_object.add(line_point);
			}
			line_points.add(line_object);
		}
		this.lines = new ArrayList<ArrayList<ArrayList<Integer>>>(line_points);	
			
		this.faces =
			new ArrayList<ArrayList<String>>(r.faces);

		this.facecolors = new ArrayList<ArrayList<ArrayList<Float>>>();
		this.facepoints = new ArrayList<ArrayList<ArrayList<Integer>>>();

		for(int i = 0; i < this.faces.size(); i++){
			ArrayList<ArrayList<Float>> color_object = new ArrayList<ArrayList<Float>>();
			ArrayList<ArrayList<Integer>> point_object = new ArrayList<ArrayList<Integer>>();
			for(int j = 0; j < this.faces.get(i).size(); j++){
				String face_string = this.faces.get(i).get(j);
				ArrayList<Float> line_buffer = new ArrayList<Float>();
				ArrayList<Float> color_buffer = new ArrayList<Float>();
				ArrayList<Integer> point_buffer = new ArrayList<Integer>();
				for(String field : face_string.split(" ")){
					line_buffer.add(Float.parseFloat(field));
				}
				for(int k = 0; k < line_buffer.size(); k++){
					if(k == line_buffer.size() - 3){
						color_buffer.add(line_buffer.get(k));
					}
					else if(k == line_buffer.size() - 2){
						color_buffer.add(line_buffer.get(k));
					}
					else if(k == line_buffer.size() - 1){
						color_buffer.add(line_buffer.get(k));
					}
					else if(k == 0){
						continue;
					}
					else{
						point_buffer.add(Math.round(line_buffer.get(k)) - 1);
					}
				}
				color_object.add(color_buffer);
				point_object.add(point_buffer);
			}
			this.facecolors.add(color_object);
			this.facepoints.add(point_object);
		}

		ArrayList<ArrayList<String>> rotation =
			new ArrayList<ArrayList<String>>(r.rotation);


		ArrayList<ArrayList<ArrayList<Float>>> rotation_points =
			new ArrayList<ArrayList<ArrayList<Float>>>();
		
			for(int i = 0; i < rotation.size(); i++){
			ArrayList<ArrayList<Float>> rotation_object = new ArrayList<ArrayList<Float>>();
			for(int j = 0; j < rotation.get(i).size(); j++){
				ArrayList<Float> rotation_point = new ArrayList<Float>();
				for(String field: rotation.get(i).get(j).split(" ")){
					rotation_point.add(Float.parseFloat(field));
				}
				rotation_object.add(rotation_point);
			}
			rotation_points.add(rotation_object);
		}
		this.rotation = new ArrayList<ArrayList<ArrayList<Float>>>(rotation_points);

		ArrayList<ArrayList<String>> scale =
			new ArrayList<ArrayList<String>>(r.scale);


		ArrayList<ArrayList<ArrayList<Float>>> scale_points =
			new ArrayList<ArrayList<ArrayList<Float>>>();
		
		for(int i = 0; i < scale.size(); i++){
			ArrayList<ArrayList<Float>> scale_object = new ArrayList<ArrayList<Float>>();
			for(int j = 0; j < scale.get(i).size(); j++){
				ArrayList<Float> scale_point = new ArrayList<Float>();
				for(String field: scale.get(i).get(j).split(" ")){
					scale_point.add(Float.parseFloat(field));
				}
				scale_object.add(scale_point);
			}
			scale_points.add(scale_object);
		}
		this.scale = new ArrayList<ArrayList<ArrayList<Float>>>(scale_points);



		ArrayList<ArrayList<String>> translation =
			new ArrayList<ArrayList<String>>(r.translation);


		ArrayList<ArrayList<ArrayList<Float>>> translation_points =
			new ArrayList<ArrayList<ArrayList<Float>>>();
		
		for(int i = 0; i < translation.size(); i++){
			ArrayList<ArrayList<Float>> translation_object = new ArrayList<ArrayList<Float>>();
			for(int j = 0; j < translation.get(i).size(); j++){
				ArrayList<Float> translation_point = new ArrayList<Float>();
				for(String field: translation.get(i).get(j).split(" ")){
					translation_point.add(Float.parseFloat(field));
				}
				translation_object.add(translation_point);
			}
			translation_points.add(translation_object);
		}
		this.translation = new ArrayList<ArrayList<ArrayList<Float>>>(translation_points);
	
	}

}
