import 'package:bloc/bloc.dart';
import 'package:hailoga/views//pages/homepage.dart';
import 'package:hailoga/views/pages/gallery.dart';
import 'package:hailoga/views/pages/myaccounts.dart';
import 'package:hailoga/views/pages/myorders.dart';
import 'package:hailoga/views/pages/vendors.dart';

enum NavigationEvents{HomePageClickedEvent, MyAccountClickedEvent,MyOrdersClickedEvent, VendorsClickedEvent, GalleryClickedEvent}

abstract class NavigationStates{}
class NavigationBloc extends Bloc<NavigationEvents, NavigationStates>{
  @override
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async*{
    switch(event){
      case NavigationEvents.HomePageClickedEvent:
        yield HomePage();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield MyAccontsPage();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield MyOrdersPage();
        break;
      case NavigationEvents.VendorsClickedEvent:
        yield Vendors();
        break;
      case NavigationEvents.GalleryClickedEvent:
        yield Gallery();
        break;
    }
  }

}