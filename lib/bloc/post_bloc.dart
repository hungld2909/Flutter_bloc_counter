import 'dart:async';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter_infinite_list/bloc/bloc.dart';
import 'package:flutter_infinite_list/models/models.dart';
//todo: note => Lưu ý: chỉ từ khai báo lớp, chúng tôi có thể nói rằng PostBloc của chúng tôi sẽ lấy PostEvents làm đầu vào và xuất ra PostStates.

class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;

  PostBloc({@required this.httpClient});
//todo: step 4: Chúng tôi có thể bắt đầu bằng cách triển khai initialStateđó sẽ là trạng thái của chúng tôi PostBloctrước khi bất kỳ sự kiện nào được thêm vào.
  @override
  get initialState => PostUninitialized();
// Chúng tôi PostBloc sẽ yield bất cứ khi nào có một trạng thái mới vì nó trả về một Stream<PostState>. Kiểm tra các khái niệm cốt lõi để biết thêm thông tin về Streamsvà các khái niệm cốt lõi khác.
// Bây giờ mỗi khi a PostEvent được thêm vào, nếu đó là một Fetchsự kiện và có nhiều bài đăng để tìm nạp, chúng tôi PostBlocsẽ tìm nạp 20 bài đăng tiếp theo.
// API sẽ trả về một mảng trống nếu chúng tôi cố gắng tìm nạp vượt quá số lượng bài viết tối đa (100), vì vậy nếu chúng tôi lấy lại một mảng trống, khối của chúng tôi sẽ yieldlà currentState trừ khi chúng tôi sẽ đặt hasReachedMaxthành đúng.
// Nếu chúng tôi không thể truy xuất các bài viết, chúng tôi ném một ngoại lệ và yield PostError().
// Nếu chúng tôi có thể truy xuất các bài đăng, chúng tôi sẽ trả lại PostLoaded()toàn bộ danh sách các bài đăng.
// Một tối ưu hóa chúng ta có thể làm là để debouncecác Eventsđể ngăn chặn spam API của chúng tôi không cần thiết. Chúng ta có thể làm điều này bằng cách ghi đè transformphương thức trong PostBloc.

//todo: Lưu ý: Biến đổi ghi đè cho phép chúng tôi chuyển đổi Luồng trước khi mapEventToState được gọi. Điều này cho phép các hoạt động như differ (), debounceTime (), v.v ... được áp dụng.
  @override
  Stream<Transition<PostEvent, PostState>> transformEvents(
    Stream<PostEvent> events,
    TransitionFunction<PostEvent, PostState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }
//todo: step 5
//Next, we need to implement mapEventToState which will be fired every time a PostEvent is added.
  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    final currentState = state;
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUninitialized) {
          final posts = await _fetchPosts(0, 20);
          yield PostLoaded(posts: posts, hasReachedMax: false);
          return;
        }
        if (currentState is PostLoaded) {
          final posts = await _fetchPosts(currentState.posts.length, 20);
          yield posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : PostLoaded(
                  posts: currentState.posts + posts,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield PostError();
      }
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax;

  Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
    final response = await httpClient.get(
        'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit');
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((rawPost) {
        return Post(
          id: rawPost['id'],
          title: rawPost['title'],
          body: rawPost['body'],
        );
      }).toList();
    } else {
      throw Exception('error fetching posts');
    }
  }
}

