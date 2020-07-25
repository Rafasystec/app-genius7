class WaiterTable{
  final int id;
  final int number;
  final int waiterId;
  final EnumTableStatus status;
  WaiterTable(this.id,this.number,this.waiterId,this.status);


}

enum EnumTableStatus{
  OTHER,
  OPEN,
  CLOSE,
  BUSY,
  RESERVED
}