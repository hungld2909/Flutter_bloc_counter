import 'package:equatable/equatable.dart';

import 'package:flutter_infinite_list/models/models.dart';
//todo: step 3: trước tiên thực hiện postState chúng ta cần có một số thông tin cần đặt ra
// PostUninitialized - sẽ thông báo cho lớp trình bày mà nó cần để hiển thị chỉ báo tải trong khi lô bài viết ban đầu được tải
// PostLoaded - sẽ nói với lớp trình bày nó có nội dung để kết xuất
// posts - sẽ là List<Post> cái sẽ được hiển thị
// hasReachedMax - sẽ cho lớp trình bày xem nó có đạt được số lượng bài viết tối đa hay không
// PostError - sẽ thông báo cho lớp trình bày rằng đã xảy ra lỗi trong khi tìm nạp bài đăng
abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostUninitialized extends PostState {
  // PostUninitialized- sẽ thông báo cho lớp trình bày mà nó cần để hiển thị chỉ báo tải trong khi lô bài viết ban đầu được tải
}

class PostError extends PostState {
  // PostError- sẽ thông báo cho lớp trình bày rằng đã xảy ra lỗi trong khi tìm nạp bài đăng
}

class PostLoaded extends PostState {
//  PostLoaded- sẽ nói với lớp trình bày nó có nội dung để kết xuất.
// *posts- sẽ là List<Post>cái sẽ được hiển thị.
// *hasReachedMax- sẽ cho lớp trình bày xem nó có đạt được số lượng bài viết tối đa hay không.
  final List<Post> posts;
  final bool hasReachedMax;
                            //? why khi khai báo thêm biến const thì lại cần thêm { }
  const PostLoaded({
    this.posts,
    this.hasReachedMax,
  });
  //Chúng tôi đã triển khai copyWith để chúng tôi có thể sao chép một thể hiện PostLoaded và cập nhật không hoặc nhiều thuộc tính một cách thuận tiện (điều này sẽ có ích sau này).
  PostLoaded copyWith({
    List<Post> posts,
    bool hasReachedMax,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [posts, hasReachedMax];

  @override
  String toString() =>
      'PostLoaded { posts: ${posts.length}, hasReachedMax: $hasReachedMax }';
}
//todo: Bây giờ chúng tôi đã thực hiện Events và States thực hiện, chúng tôi có thể tạo ra của chúng tôi PostBloc.