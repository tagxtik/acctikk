 import 'package:bloc/bloc.dart';

enum NavigationEvent {
  HomePageClickedEvent,
  ReportsClickedEvent,
  OrgClickedEvent,
  JornalEntryClickedEvent,
  JornalEntryTransactionClickedEvent,
  AccountsClickedEvent,
  SettingClickedEvent,
  logDataClickEvent,
  MasterledgerClickEvent,
  SubledgerClickEvent,
}

class NavigationCubit extends Cubit<NavigationEvent> {
  NavigationCubit() : super(NavigationEvent.HomePageClickedEvent);

  void HomePage() {
    emit(NavigationEvent.HomePageClickedEvent);
  }

  void Reports() {
    emit(NavigationEvent.ReportsClickedEvent);
  }

  void Setting() {
    emit(NavigationEvent.SettingClickedEvent);
  }

  void Org() {
    emit(NavigationEvent.OrgClickedEvent);
  }

  void Accoutnts() {
    emit(NavigationEvent.AccountsClickedEvent);
  }

  void JornalEntry() {
    emit(NavigationEvent.JornalEntryClickedEvent);
  }
 void MasterLedger() {
    emit(NavigationEvent.MasterledgerClickEvent
    );
  }
   void SubLedger() {
    emit(NavigationEvent.SubledgerClickEvent
    );
  }
  void JornalTrans() {
    emit(NavigationEvent.JornalEntryTransactionClickedEvent);
  }

  void LogData() {
    emit(NavigationEvent.logDataClickEvent);
  }
 
}
