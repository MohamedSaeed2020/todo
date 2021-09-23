abstract class AppStates{}
///all states according to order of calling them
class AppInitialState extends AppStates{}
class GetDatabaseLoadingState extends AppStates{}
class CreateDatabaseState extends AppStates{}
class GetDataFromDatabaseState extends AppStates{}
class ChangeBottomNavBarState extends AppStates{}
class InsertToDatabaseState extends AppStates{}
class ChangeBottomSheetState extends AppStates{}
class UpdateDatabaseState extends AppStates{}
class DeleteDatabaseState extends AppStates{}
