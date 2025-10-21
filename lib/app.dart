import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/remote/bills_api.dart';
import 'data/repository/global_repository.dart';
import 'features/bills/view/bills_page.dart';
import 'state/bills_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = BillsApi(client: BillsApi.defaultClient);
    final repo = GlobalRepository(api);

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => BillsBloc(repo))],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cred Bills Carousel',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Lato',
          scaffoldBackgroundColor: const Color(0xFFF7F7F7),
        ),
        home: const BillsPage(),
      ),
    );
  }
}
