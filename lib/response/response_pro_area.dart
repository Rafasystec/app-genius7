
const ID    = 'id';
const DESC  = 'description';
const COUNT = 'count';
const BUNNER = 'urlBunner';

class ResponseProArea{
  final int id;
  final String description;
  final int count;
  final String urlBunner;

  ResponseProArea(this.id, this.description,this.count,this.urlBunner);

  factory ResponseProArea.fromJson(Map<String, dynamic> json){
    return ResponseProArea(json[ID], json[DESC], json[COUNT],json[BUNNER]);
  }
}