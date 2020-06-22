import 'package:equatable/equatable.dart';
//todo: Step 1: khởi tạo đối tượng.
// bao gồm các thuộc tính id, title and body
class Post extends Equatable {
  // Equatable dùng để so sánh  
  // Chúng tôi mở rộng Equatableđể chúng tôi có thể so sánh Posts; 
  // theo mặc định, toán tử đẳng thức trả về true khi và chỉ khi cái này và cái kia là cùng một thể hiện.
  final int id;
  final String title;
  final String body;

  const Post({this.id, this.title, this.body});

  @override
  List<Object> get props => [id, title, body];

  @override
  String toString() => 'Post { id: $id }';
  // Chúng tôi ghi đè toString hàm để có biểu diễn chuỗi tùy chỉnh của chúng tôi Post sau này.
}

//Now that we have our Post object model, let’s start working on the Business Logic Component (bloc).