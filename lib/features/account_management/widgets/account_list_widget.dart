
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/account_controller.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';

import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/account_management/widgets/account_info_widget.dart';


class AccountListWidget extends StatefulWidget {
  final bool isHome;
  final ScrollController scrollController;
  const AccountListWidget({Key? key, required this.scrollController, this.isHome = false}) : super(key: key);

  @override
  State<AccountListWidget> createState() => _AccountListWidgetState();
}

class _AccountListWidgetState extends State<AccountListWidget> {
  @override
  Widget build(BuildContext context) {

    return GetBuilder<AccountController>(
      builder: (accountController) {

        if(accountController.accountModel == null) {
          return const CustomLoaderWidget();
        }

        return (accountController.accountModel?.accountList?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: widget.scrollController,
          onPaginate: (int? offset) async => await accountController.getAccountList(offset ?? 1),
          totalSize: accountController.accountModel?.totalSize,
          offset: accountController.accountModel?.offset,
          itemView: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.isHome && (accountController.accountModel?.accountList?.length ?? 0) > 3 ? 3 : accountController.accountModel?.accountList?.length,
            physics: widget.isHome ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
              return AccountCardWidget(
                account: accountController.accountModel?.accountList?[index],
                index: index,
                isHome:widget.isHome,
              );

            },
          ),
        ) : const NoDataWidget();
      },
    );
  }
}
