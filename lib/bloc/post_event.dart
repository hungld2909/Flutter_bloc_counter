import 'package:equatable/equatable.dart';
//todo: Step 2
// At a high level, it will be responding to user input (scrolling) 
// and fetching more posts in order for the presentation layer to display them. Let’s start by creating our Event.
abstract class PostEvent extends Equatable {
  //Một lần nữa, chúng tôi đang ghi đè toString cho một đại diện chuỗi dễ đọc hơn cho sự kiện của chúng tôi. Một lần nữa, 
  // chúng tôi đang mở rộng Equatableđể chúng tôi có thể so sánh các trường hợp cho sự bình đẳng.
  @override
  List<Object> get props => [];
}

class Fetch extends PostEvent {}
// Chúng tôi PostBloc sẽ chỉ phản ứng với một sự kiện duy nhất; 
// Fetch sẽ được thêm bởi lớp trình bày bất cứ khi nào nó cần thêm bài viết để trình bày. 
// Vì Fetch sự kiện của chúng tôi là một loại PostEvent chúng tôi có thể tạo bloc/post_event.dart và triển khai sự kiện như vậy.

//! important
//! Để tóm tắt lại, chúng tôi PostBloc sẽ nhận PostEvents và chuyển đổi chúng thành PostStates. 
//! Chúng tôi đã xác định tất cả PostEvents(Tìm nạp) để tiếp theo hãy xác định PostState.