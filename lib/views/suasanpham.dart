import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_application/model/suasp.dart';
import 'package:sales_application/views/color.dart';
import 'package:sales_application/views/gia_sp.dart';
import 'package:sales_application/views/giamgia.dart';
import 'package:sales_application/views/loaisanpham.dart';
import 'package:sales_application/views/quanlysanpham.dart';
import 'package:sales_application/views/soluongkho.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import'package:firebase_storage/firebase_storage.dart';
import '../model/themsp.dart';
class SuaSP extends StatefulWidget {
  final Map<dynamic, dynamic> sp;

  SuaSP(this.sp, {Key? key}) : super(key: key);

  @override
  _SuaSPState createState() => _SuaSPState();
}
class _SuaSPState extends State<SuaSP> {
  late DocumentReference _reference;
  GlobalKey<FormState> _key = GlobalKey();
  String _selected="";
  late TextEditingController _tensp ;
  late TextEditingController _mota ;
  String _kichco_sp="";
  int _charCount1 = 0;
  int _charCount = 0;
  @override
  void initState() {
    super.initState();
    SuaMap.myMap=widget.sp;
    _tensp = TextEditingController(text: SuaMap.myMap['name']);
    _mota= TextEditingController(text: SuaMap.myMap['Descriptions']);
    _charCount1 =_mota.text.length ;
    _charCount = _tensp.text.length;
    _selected=SuaMap.myMap['image'];
    _reference = FirebaseFirestore.instance.collection('products').doc(SuaMap.myMap['id']);
    if(SuaMap.myMap['sizeS']>0)
      _kichco_sp+="S ";
    if(SuaMap.myMap['sizeM']>0)
      _kichco_sp+="M ";
    if(SuaMap.myMap['sizeL']>0)
      _kichco_sp+="L ";
    if(SuaMap.myMap['sizeXL']>0)
      _kichco_sp+="XL ";
  }
  @override
  Widget build(BuildContext context) {

   return Scaffold(
        appBar: AppBar(
          title: Text("Sửa sản phẩm",style: TextStyle(color: MyColor.dark_pink,fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: MyColor.light_pink,
          actions: [
            TextButton(onPressed: () async {
              SuaMap.myMap['name']=_tensp.text;
              SuaMap.myMap['Descriptions']=_mota.text;
              // Map<String,dynamic> dataToSend={
              //   'Descriptions':SuaMap.getValueByKey('Descriptions'),
              //   'category':SuaMap.getValueByKey('category'),
              //   'discount':SuaMap.getValueByKey('discount'),
              //   //image:
              //   'name':SuaMap.getValueByKey('name'),
              //   'price':SuaMap.getValueByKey('price'),
              //   'sizeS':SuaMap.getValueByKey('sizeS'),
              //   'sizeM':SuaMap.getValueByKey('sizeM'),
              //   'sizeL':SuaMap.getValueByKey('sizeL'),
              //   'sizeXL':SuaMap.getValueByKey('sizeXL'),
              //   'status':true
              // };
              try {
                await _reference.update(Map<String,dynamic>.from(SuaMap.myMap));
                print('Tài liệu được cập nhật thành công trên Firestore.');
              } catch (e) {
                print('Lỗi khi cập nhật tài liệu: $e');
              }
              SuaMap.myMap= {
                'id': 0,
                'image':"" ,
                'name':"",
                'Descriptions':"",
                'category':"",
                'price':0,
                'sizeS':0,
                'sizeM':0,
                'sizeL':0,
                'sizeXL':0,
                'discount':0
              };
              Navigator.push( context,
                MaterialPageRoute(builder: (context) => QuanLySP()),);
            }, child: Text("Lưu",style: TextStyle(color: MyColor.dark_pink,fontWeight: FontWeight.bold,fontSize: 17)))
          ],
          leading: IconButton(onPressed: ()async{
            Navigator.push( context,
              MaterialPageRoute(builder: (context) => QuanLySP()),);
          }, icon: Icon(Icons.arrow_back,color: MyColor.dark_pink)),
        ),
        body:
        SingleChildScrollView(
          child:Column(
            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/60),
              Container(
                  height: 140,
                  padding:const EdgeInsets.all(10),
                  decoration:   BoxDecoration(
                    color:  MyColor.light_grey,
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child:InkWell(
                              onTap: (){_pickImage();},
                              child: _selected!=""? Image.network(_selected!):Center(
                                child: Text("Thêm ảnh",style:TextStyle(fontSize: 14)),/*TODO:*/
                              ),
                            ),
                          ),
                          if (_selected != "")
                            ...[
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.close_rounded),
                                  onPressed: () {
                                    setState(() {
                                      _selected = "";
                                    });
                                  },
                                ),
                              ),
                            ],

                        ],
                      )

                    ],

                  )
              )
              ,
              SizedBox(height: MediaQuery.of(context).size.height/60),
              Container(
                height: 120,
                padding:EdgeInsets.all(10),
                constraints:BoxConstraints(maxHeight: 200.0),
                decoration:  BoxDecoration(
                    color:  MyColor.light_grey
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: 'Tên sản phẩm ', style: TextStyle(fontWeight: FontWeight.normal,fontSize: 13,color: Colors.black,decoration: TextDecoration.none,)),
                              TextSpan(text: '*', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.red,decoration: TextDecoration.none,)),
                            ],
                          ),
                        ),
                        Text("${_charCount.toString()}/120")
                      ],
                    ),
                    TextField(
                      controller: _tensp/*Todo:*/,
                      maxLines:2,
                      onChanged: (text) {
                        setState(() {
                          _charCount = text.length;
                          if (_charCount >119) {
                            // Nếu vượt quá giới hạn, cắt bớt văn bản nhập mới
                            _mota.text = text.substring(0, 119);
                            // Di chuyển con trỏ về cuối văn bản
                            _mota.selection = TextSelection.fromPosition(
                              TextPosition(offset: _mota.text.length),
                            );
                          }
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: 'Nhập tên sản phẩm',
                          border: InputBorder.none // Loại bỏ đường gạch chân khi không có focus
                      ),
                    )
                  ],

                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/60),
              Container(
                height: 120,
                padding:const EdgeInsets.all(10),
                constraints:const BoxConstraints(maxHeight: 200.0),
                decoration:  BoxDecoration(
                    color:  MyColor.light_grey
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: null,
                            style: DefaultTextStyle.of(context).style,
                            children: const <TextSpan>[
                              TextSpan(text: 'Mô tả sản phẩm ', style: TextStyle(fontWeight: FontWeight.normal,fontSize: 13,color: Colors.black,decoration: TextDecoration.none,)),
                              TextSpan(text: '*', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.red,decoration: TextDecoration.none,)),
                            ],
                          ),
                        ),
                        Text("${_charCount1.toString()}/3000")/*Todo:0/3000*/
                      ],
                    ),
                    TextField(
                      controller: _mota/*Todo:*/,
                      maxLines:2,
                      onChanged: (text) {
                        setState(() {
                          _charCount1 = text.length;
                          if (_charCount1 >2999) {
                            // Nếu vượt quá giới hạn, cắt bớt văn bản nhập mới
                            _mota.text = text.substring(0, 2999);
                            // Di chuyển con trỏ về cuối văn bản
                            _mota.selection = TextSelection.fromPosition(
                              TextPosition(offset: _mota.text.length),
                            );
                          }
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: 'Nhập mô tả sản phẩm',
                          border: InputBorder.none // Loại bỏ đường gạch chân khi không có focus
                      ),
                    )
                  ],

                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/60),
              ///Phần chọn
              Container(
                height: 250,
                padding:const EdgeInsets.all(10),
                decoration:  BoxDecoration(
                    color:  MyColor.light_grey
                ),
                child:Column(
                  children: [
                    ///Loáip
                    Expanded(

                        child: InkWell(onTap: (){
                          Navigator.push( context,
                            MaterialPageRoute(builder: (context) => SuaLoaiSP(SuaMap.myMap['id'])),);
                        },
                          child: Row(
                            children: [
                              const Expanded(child: Icon(Icons.category)), // Icon ở đầu
                              Expanded(child: RichText(
                                text: TextSpan(
                                  text: null,
                                  style: DefaultTextStyle.of(context).style,
                                  children:  <TextSpan>[
                                    TextSpan(text: 'Loại sản phẩm ', style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14,color: Colors.black,decoration: TextDecoration.none,)),
                                    TextSpan(text: '*', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.red,decoration: TextDecoration.none,)),
                                  ],
                                ),
                              ),flex: 3,),
                              Expanded(child: Text(SuaMap.myMap['category'])),// Khoảng trắng giữa hai icon
                              Expanded(child: Icon(Icons.arrow_forward_ios)),  // Icon ở cuối
                            ],
                          ),)),
                    ///So luong
                    Expanded(
                        child: InkWell(onTap: (){
                          Navigator.push( context,
                            MaterialPageRoute(builder: (context) => SSoLuongKho(SuaMap.myMap['id'])),);
                        },
                          child: Row(
                            children: [
                              Expanded(child: Icon(Icons.warehouse)), // Icon ở đầu
                              Expanded(child: RichText(
                                text: TextSpan(
                                  text: null,
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(text: 'Số lượng kho ', style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14,color: Colors.black,decoration: TextDecoration.none,)),
                                    TextSpan(text: '*', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.red,decoration: TextDecoration.none,)),
                                  ],
                                ),
                              ),flex: 3,),
                              Expanded(child: Text("${SuaMap.myMap['sizeS']+SuaMap.myMap['sizeM']+SuaMap.myMap['sizeL']+SuaMap.myMap['sizeXL']}")),// Khoảng trắng giữa hai icon
                              Expanded(child: Icon(Icons.arrow_forward_ios)),  // Icon ở cuối
                            ],
                          ),)),


                    ///Gia
                    Expanded(
                        child: InkWell(
                          onTap: (){
                            Navigator.push( context,
                              MaterialPageRoute(builder: (context) => SGiaSP(SuaMap.myMap['id'])),);
                          },
                          child: Row(
                            children: [
                              Expanded(child: Icon(Icons.price_change)), // Icon ở đầu
                              Expanded(child:RichText(
                                text: TextSpan(
                                  text: null,
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(text: 'Giá bán ', style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14,color: Colors.black,decoration: TextDecoration.none,)),
                                    TextSpan(text: '*', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.red,decoration: TextDecoration.none,)),
                                  ],
                                ),
                              )
                                ,flex: 3,),
                              Expanded(child: Text("${SuaMap.myMap['price']}",maxLines: 1,)),// Khoảng trắng giữa hai icon
                              Expanded(child: Icon(Icons.arrow_forward_ios)),  // Icon ở cuối
                            ],
                          ),)),
                    ///Mua giam gia
                    Expanded(

                        child: InkWell(
                          onTap: (){
                            Navigator.push( context,
                              MaterialPageRoute(builder: (context) => SGiamGia(SuaMap.myMap['id'])),);
                          },
                          child: Row(
                            children: [
                              Expanded(child: Icon(Icons.percent)), // Icon ở đầu
                              Expanded(child: Text("Giảm giá",style:TextStyle(fontSize: 14)),flex: 3,),
                              Expanded(child: Text("${SuaMap.myMap['discount']}")),// Khoảng trắng giữa hai icon
                              Expanded(child: Icon(Icons.arrow_forward_ios)),  // Icon ở cuối
                            ],
                          ),)),

                    ///Kich Co
                    Expanded(


                        child: InkWell(
                          onTap: (){},
                          child: Row(
                            children:[
                              Expanded(child: Icon(Icons.format_size)),
                              Expanded(child: Text("Kích cỡ",style:TextStyle(fontSize: 14)),flex: 3,),
                              Expanded(child: Text("")),
                              Expanded(child: Text(_kichco_sp)),
                            ],
                          ),)),
                  ],
                ) ,
              ),
            ],

          ),
        )
    );
  }
  Future _pickImage() async{
    final returnImage=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(returnImage==null)return;
    Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageReference.putFile(File(returnImage.path));

    setState(() async {
      //_selected=File(returnImage!.path);
      uploadTask.whenComplete(() async {
        // Lấy URL của hình ảnh đã upload
        String imageUrl = await storageReference.getDownloadURL();

        // Cập nhật trạng thái và in ra console URL của hình ảnh
        setState(() {
          _selected = imageUrl;
          print("Image URL: $imageUrl");
          SuaMap.myMap['image'] = imageUrl;
        });
      });
    }
    );
  }
}
