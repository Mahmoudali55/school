import 'package:easy_localization/easy_localization.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/select_interface/data/model/user_type_model.dart';

class InterfaceRepository {
  List<UserTypeModel> getUserTypes() {
    return [
      UserTypeModel(id: 'student', title: AppLocalKay.student.tr(), icon: 'school'),
      UserTypeModel(id: 'parent', title: AppLocalKay.parent.tr(), icon: 'family_restroom'),
      UserTypeModel(id: 'teacher', title: AppLocalKay.teacher.tr(), icon: 'person'),
      UserTypeModel(id: 'admin', title: AppLocalKay.admin.tr(), icon: 'apartment'),
    ];
  }
}
