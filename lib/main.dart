import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list/bloc/bloc.dart';
import 'package:flutter_infinite_list/models/models.dart';
//todo: note Chúng tôi HomePagekhông biết Postschúng đến từ đâu hoặc chúng được lấy như thế nào. Ngược lại, chúng tôi PostBlockhông biết làm thế nào Stateđược hiển thị, nó chỉ đơn giản chuyển đổi các Event thành các State
void main() {
  //todo: step 12
  //Để bảo Bloc sử dụng SimpleBlocDelegate, chúng tôi chỉ cần điều chỉnh chức năng chính của chúng tôi.
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Infinite Scroll',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
        ),
//todo: step 6
//Trong Apptiện ích của chúng tôi , chúng tôi sử dụng BlocProviderđể tạo và cung cấp một thể hiện của PostBloccây con.
// Ngoài ra, chúng tôi thêm một Fetchsự kiện để khi ứng dụng tải, nó yêu cầu lô Bài viết ban đầu.
        body: BlocProvider(
          create: (context) =>
              PostBloc(httpClient: http.Client())..add(Fetch()),
          child: HomePage(),
        ),
      ),
    );
  }
}
//todo: step 7
//Tiếp theo, chúng tôi cần triển khai HomePagewidget của chúng tôi sẽ trình bày các bài đăng của chúng tôi và nối với chúng tôi PostBloc.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
//HomePagelà StatefulWidgetbởi vì nó sẽ cần phải duy trì a ScrollController. 
// Trong initState, chúng tôi thêm một người nghe vào để chúng ScrollControllertôi có thể phản hồi các sự kiện cuộn. 
// Chúng tôi cũng truy cập PostBloc ví dụ của chúng tôi thông qua BlocProvider.of<PostBloc>(context).
class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  PostBloc _postBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostError) {
          return Center(
            child: Text('failed to fetch posts'),
          );
        }
        if (state is PostLoaded) {
          if (state.posts.isEmpty) {
            return Center(
              child: Text('no posts'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= state.posts.length
                  ? BottomLoader()
                  : PostWidget(post: state.posts[index]);
            },
            itemCount: state.hasReachedMax
                ? state.posts.length
                : state.posts.length + 1,
            controller: _scrollController,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _postBloc.add(Fetch());
    }
  }
}
//todo: step 8
// Di chuyển cùng, phương thức xây dựng của chúng tôi trả về a BlocBuilder. BlocBuilderlà một tiện ích Flutter từ gói flutter_bloc xử lý việc xây dựng một widget để đáp ứng với các trạng thái khối mới. Bất cứ khi nào PostBloctrạng thái của chúng tôi thay đổi, chức năng xây dựng của chúng tôi sẽ được gọi với cái mới PostState.
//! note: Chúng ta cần nhớ dọn dẹp sau chính mình và vứt bỏ chúng ta ScrollControllerkhi StatefulWidget bị loại bỏ.
// Bất cứ khi nào người dùng cuộn, chúng tôi sẽ tính toán khoảng cách từ cuối trang đến mức nào và nếu khoảng cách là chúng _scrollThresholdtôi sẽ thêm một Fetchsự kiện để tải thêm bài đăng.

//todo: step 9 Tiếp theo, chúng tôi cần triển khai BottomLoaderwidget của chúng tôi sẽ cho người dùng biết rằng chúng tôi đang tải thêm bài viết.
class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
//todo: step 10: Cuối cùng, chúng ta cần triển khai PostWidgetbài đăng của mình.

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${post.id}',
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text(post.title),
      isThreeLine: true,
      subtitle: Text(post.body),
      dense: true,
    );
  }
}
