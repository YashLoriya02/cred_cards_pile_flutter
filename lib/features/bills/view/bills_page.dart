import 'package:cred_bills_carousel/features/bills/widgets/two_cards_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../state/bills_bloc.dart';
import '../widgets/vertical_carousel.dart';

class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BillsBloc>().add(
      const BillsLoadRequested(
        urlOverride:
            'https://jsonblob.com/api/jsonBlob/1425067032428339200', // 2 items
        // urlOverride:
        //     'https://jsonblob.com/api/jsonBlob/1425066643679272960', // 9 items
      ),
    );
  }

  @override
  void dispose() {
    context.read<BillsBloc>().add(const BillsDispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<BillsBloc, BillsState>(
          builder: (context, state) {
            switch (state.status) {
              case BillsStatus.initial:
              case BillsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case BillsStatus.failure:
                return Center(child: Text('Failed: ${state.error}'));
              case BillsStatus.success:
                final section = state.section!;
                final cards = section.cards;
                final isTwo = cards.length <= 2;

                return isTwo
                    ? BillsTwoCardList(
                        globalFlipIndex: state.currentFlipIndex,
                        title: section.title,
                        cards: cards,
                      )
                    : VerticalBillsCarousel(
                        section: section,
                        globalFlipIndex: state.currentFlipIndex,
                      );
            }
          },
        ),
      ),
    );
  }
}
