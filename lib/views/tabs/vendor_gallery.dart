import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:hailoga/services/vendor_service.dart';
class VendorGallery extends StatefulWidget {
  final VendorsModel vendor;

  const VendorGallery({Key key, this.vendor}) : super(key: key);
  @override
  _VendorGallery createState() => _VendorGallery();
}

class _VendorGallery extends State<VendorGallery> {
  VendorsService get service => GetIt.I<VendorsService>();
  APIResponse<List<VendorImage>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchImgs();
  }

  _fetchImgs() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getImages(widget.vendor.id);
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Builder(
          builder: (_){
            if(_isLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if(_apiResponse.error){
              return Center(child: Text(_apiResponse.errorMessage),);
            }
            return ListView.separated(
                itemBuilder: (_, index){
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                      elevation: 8,
                      child: Container(
                        width: screenWidth-2,
                        height: 300,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage("${APIAddress.api}"+_apiResponse.data[index].imgLocation)
                          )
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_,__)=>Divider(height: 2,color: Colors.transparent,),
                itemCount: _apiResponse.data.length);
          },
        )
    );
  }
}
