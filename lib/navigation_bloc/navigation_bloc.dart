import 'package:bloc/bloc.dart';
import 'package:hailoga/views//pages/homepage.dart';
import 'package:hailoga/views/pages/appointmetns.dart';
import 'package:hailoga/views/pages/bookings.dart';
import 'package:hailoga/views/pages/gallery.dart';
import 'package:hailoga/views/pages/myaccounts.dart';
import 'package:hailoga/views/pages/myorders.dart';
import 'package:hailoga/views/pages/notifications.dart';
import 'package:hailoga/views/pages/vendors.dart';

enum NavigationEvents{HomePageClickedEvent, MyAccountClickedEvent,MyOrdersClickedEvent,
  VendorsClickedEvent, GalleryClickedEvent, NotificationClickedEvent, AppointmentsClickedEvent, BookingsClickedEvent}

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
        yield MyAccountsPage();
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
      case NavigationEvents.NotificationClickedEvent:
        yield UserNotifications();
        break;
      case NavigationEvents.AppointmentsClickedEvent:
        yield UsersAppointments();
        break;
      case NavigationEvents.BookingsClickedEvent:
        yield UsersBookings();
        break;
    }
  }

}