import 'package:bloc/bloc.dart';
//todo: step 11
// Thêm một phần thưởng khi sử dụng thư viện khối là chúng ta có thể có quyền truy cập vào tất cả Transitionsở một nơi.
// Mặc dù trong ứng dụng này chúng ta chỉ có một khối, nhưng nó khá phổ biến trong các ứng dụng lớn hơn để có nhiều khối quản lý các phần khác nhau của trạng thái của ứng dụng.
// Nếu chúng ta muốn có thể làm một cái gì đó để đáp lại tất cả, Transitionschúng ta chỉ có thể tạo ra thứ của riêng mình BlocDelegate.
class SimpleBlocDelegate extends BlocDelegate {
  // Tất cả chúng ta cần làm là mở rộng BlocDelegatevà ghi đè onTransitionphương thức.
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}