import java.util.*;
import java.util.Arrays;

// Leitor de arquivos .dat
class Reader {

	ArrayList<String> test_array = new ArrayList<String>();
	
	ArrayList<ArrayList<String>> metadata = 
		new ArrayList<ArrayList<String>>();

	ArrayList<ArrayList<String>> names = 
		new ArrayList<ArrayList<String>>();
	
	ArrayList<ArrayList<String>> properties =
		new ArrayList<ArrayList<String>>();
	
	ArrayList<ArrayList<String>> points =
		new ArrayList<ArrayList<String>>();
	
	ArrayList<ArrayList<String>> lines = 
		new ArrayList<ArrayList<String>>();

	ArrayList<ArrayList<String>> faces =
		new ArrayList<ArrayList<String>>();

	ArrayList<ArrayList<String>> rotation =
		new ArrayList<ArrayList<String>>();

	ArrayList<ArrayList<String>> scale =
		new ArrayList<ArrayList<String>>();

	ArrayList<ArrayList<String>> translation = 
		new ArrayList<ArrayList<String>>();
	
	Reader(){
	}
	
	public void testvalues(){

		this.test_array.add(metadata.get(0).get(0));
		this.test_array.add(metadata.get(0).get(1));
		this.test_array.add(metadata.get(0).get(2));
	
		for(int i = 0; i < this.names.size(); i++){
			for(int j = 0; j < this.names.get(i).size(); j++){
				this.test_array.add(this.names.get(i).get(j));

			}

			for(int j = 0; j < this.properties.get(i).size(); j++){
				this.test_array.add(this.properties.get(i).get(j));

			}

			for(int j = 0; j < this.points.get(i).size(); j++){
				this.test_array.add(this.points.get(i).get(j));

			}

			for(int j = 0; j < this.lines.get(i).size(); j++){
				this.test_array.add(this.lines.get(i).get(j));

			}

			for(int j = 0; j < this.faces.get(i).size(); j++){
				this.test_array.add(this.faces.get(i).get(j));

			}

			for(int j = 0; j < this.rotation.get(i).size(); j++){
				this.test_array.add(this.rotation.get(i).get(j));

			}
			for(int j = 0; j < this.scale.get(i).size(); j++){
				this.test_array.add(this.scale.get(i).get(j));

			}
			for(int j = 0; j < this.translation.get(i).size(); j++){
				this.test_array.add(this.translation.get(i).get(j));

			}
		}
	}
	
	public void read(String[] lines){
		ArrayList<String> meta = new ArrayList<String>();
		meta.add(lines[0]);
		meta.add(lines[1]);
		meta.add(lines[2]);
		this.metadata.add(meta);

		int i = 3;
		while( i < lines.length ){

			meta = new ArrayList<String>();
			meta.add(lines[i]);
			this.names.add(meta);

			i += 1;
			ArrayList<String> property = new ArrayList<String>();
			property.add(lines[i]);
			this.properties.add(property);



			ArrayList<Integer> integer_property = new ArrayList<Integer>();
			for (String field : lines[i].split(" ")) integer_property.add(Integer.parseInt(field));

			int p = integer_property.get(0);
			int l = integer_property.get(1);
			int f = integer_property.get(2);
				
			//p
			ArrayList<String> LINES = new ArrayList<String>();
			ArrayList<String> POINTS = new ArrayList<String>();
			ArrayList<String> FACES = new ArrayList<String>();
			for(int j = i + 1; j < i + 1 + p ; j++){
				POINTS.add(lines[j]);
			}
	
			//l
			for(int j = i + 1 + p ; j < i + 1 + p + l; j++){
				LINES.add(lines[j]);
			}
	
		
			//f
			for(int j = i + 1 + p + l; j < i + 1 + p + l + f; j++){
				FACES.add(lines[j]);
			}

			this.lines.add(LINES);
			this.points.add(POINTS);
			this.faces.add(FACES);
			
			int j = i + 1 + p + l + f;
			ArrayList<String> ROT = new ArrayList<String>();
			ROT.add(lines[j]);
			
			j += 1;
			ArrayList<String> SCALE = new ArrayList<String>();
			SCALE.add(lines[j]);			

			j += 1;
			ArrayList<String> TRANS = new ArrayList<String>();
			TRANS.add(lines[j]);		

			this.rotation.add(ROT);
			this.scale.add(SCALE);
			this.translation.add(TRANS);
		
			j += 1;	
			if( j > lines.length) {
				break;
			}
			i = j;
		}
	}
}
