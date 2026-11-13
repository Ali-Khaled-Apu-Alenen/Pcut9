// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoClipData {

 String get id; String get filePath; String get fileName; Duration get totalDuration; Duration get trimStart; Duration? get trimEnd;// Normalized crop box: x, y in [0.0, 1.0], width, height in [0.1, 1.0]
 double get cropX; double get cropY; double get cropWidth; double get cropHeight; double get speed; double get volume;
/// Create a copy of VideoClipData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoClipDataCopyWith<VideoClipData> get copyWith => _$VideoClipDataCopyWithImpl<VideoClipData>(this as VideoClipData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoClipData&&(identical(other.id, id) || other.id == id)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.trimStart, trimStart) || other.trimStart == trimStart)&&(identical(other.trimEnd, trimEnd) || other.trimEnd == trimEnd)&&(identical(other.cropX, cropX) || other.cropX == cropX)&&(identical(other.cropY, cropY) || other.cropY == cropY)&&(identical(other.cropWidth, cropWidth) || other.cropWidth == cropWidth)&&(identical(other.cropHeight, cropHeight) || other.cropHeight == cropHeight)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.volume, volume) || other.volume == volume));
}


@override
int get hashCode => Object.hash(runtimeType,id,filePath,fileName,totalDuration,trimStart,trimEnd,cropX,cropY,cropWidth,cropHeight,speed,volume);

@override
String toString() {
  return 'VideoClipData(id: $id, filePath: $filePath, fileName: $fileName, totalDuration: $totalDuration, trimStart: $trimStart, trimEnd: $trimEnd, cropX: $cropX, cropY: $cropY, cropWidth: $cropWidth, cropHeight: $cropHeight, speed: $speed, volume: $volume)';
}


}

/// @nodoc
abstract mixin class $VideoClipDataCopyWith<$Res>  {
  factory $VideoClipDataCopyWith(VideoClipData value, $Res Function(VideoClipData) _then) = _$VideoClipDataCopyWithImpl;
@useResult
$Res call({
 String id, String filePath, String fileName, Duration totalDuration, Duration trimStart, Duration? trimEnd, double cropX, double cropY, double cropWidth, double cropHeight, double speed, double volume
});




}
/// @nodoc
class _$VideoClipDataCopyWithImpl<$Res>
    implements $VideoClipDataCopyWith<$Res> {
  _$VideoClipDataCopyWithImpl(this._self, this._then);

  final VideoClipData _self;
  final $Res Function(VideoClipData) _then;

/// Create a copy of VideoClipData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? filePath = null,Object? fileName = null,Object? totalDuration = null,Object? trimStart = null,Object? trimEnd = freezed,Object? cropX = null,Object? cropY = null,Object? cropWidth = null,Object? cropHeight = null,Object? speed = null,Object? volume = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,trimStart: null == trimStart ? _self.trimStart : trimStart // ignore: cast_nullable_to_non_nullable
as Duration,trimEnd: freezed == trimEnd ? _self.trimEnd : trimEnd // ignore: cast_nullable_to_non_nullable
as Duration?,cropX: null == cropX ? _self.cropX : cropX // ignore: cast_nullable_to_non_nullable
as double,cropY: null == cropY ? _self.cropY : cropY // ignore: cast_nullable_to_non_nullable
as double,cropWidth: null == cropWidth ? _self.cropWidth : cropWidth // ignore: cast_nullable_to_non_nullable
as double,cropHeight: null == cropHeight ? _self.cropHeight : cropHeight // ignore: cast_nullable_to_non_nullable
as double,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoClipData].
extension VideoClipDataPatterns on VideoClipData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoClipData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoClipData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoClipData value)  $default,){
final _that = this;
switch (_that) {
case _VideoClipData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoClipData value)?  $default,){
final _that = this;
switch (_that) {
case _VideoClipData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String filePath,  String fileName,  Duration totalDuration,  Duration trimStart,  Duration? trimEnd,  double cropX,  double cropY,  double cropWidth,  double cropHeight,  double speed,  double volume)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoClipData() when $default != null:
return $default(_that.id,_that.filePath,_that.fileName,_that.totalDuration,_that.trimStart,_that.trimEnd,_that.cropX,_that.cropY,_that.cropWidth,_that.cropHeight,_that.speed,_that.volume);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String filePath,  String fileName,  Duration totalDuration,  Duration trimStart,  Duration? trimEnd,  double cropX,  double cropY,  double cropWidth,  double cropHeight,  double speed,  double volume)  $default,) {final _that = this;
switch (_that) {
case _VideoClipData():
return $default(_that.id,_that.filePath,_that.fileName,_that.totalDuration,_that.trimStart,_that.trimEnd,_that.cropX,_that.cropY,_that.cropWidth,_that.cropHeight,_that.speed,_that.volume);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String filePath,  String fileName,  Duration totalDuration,  Duration trimStart,  Duration? trimEnd,  double cropX,  double cropY,  double cropWidth,  double cropHeight,  double speed,  double volume)?  $default,) {final _that = this;
switch (_that) {
case _VideoClipData() when $default != null:
return $default(_that.id,_that.filePath,_that.fileName,_that.totalDuration,_that.trimStart,_that.trimEnd,_that.cropX,_that.cropY,_that.cropWidth,_that.cropHeight,_that.speed,_that.volume);case _:
  return null;

}
}

}

/// @nodoc


class _VideoClipData implements VideoClipData {
  const _VideoClipData({required this.id, required this.filePath, required this.fileName, required this.totalDuration, this.trimStart = Duration.zero, this.trimEnd, this.cropX = 0.0, this.cropY = 0.0, this.cropWidth = 1.0, this.cropHeight = 1.0, this.speed = 1.0, this.volume = 1.0});
  

@override final  String id;
@override final  String filePath;
@override final  String fileName;
@override final  Duration totalDuration;
@override@JsonKey() final  Duration trimStart;
@override final  Duration? trimEnd;
// Normalized crop box: x, y in [0.0, 1.0], width, height in [0.1, 1.0]
@override@JsonKey() final  double cropX;
@override@JsonKey() final  double cropY;
@override@JsonKey() final  double cropWidth;
@override@JsonKey() final  double cropHeight;
@override@JsonKey() final  double speed;
@override@JsonKey() final  double volume;

/// Create a copy of VideoClipData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoClipDataCopyWith<_VideoClipData> get copyWith => __$VideoClipDataCopyWithImpl<_VideoClipData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoClipData&&(identical(other.id, id) || other.id == id)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.trimStart, trimStart) || other.trimStart == trimStart)&&(identical(other.trimEnd, trimEnd) || other.trimEnd == trimEnd)&&(identical(other.cropX, cropX) || other.cropX == cropX)&&(identical(other.cropY, cropY) || other.cropY == cropY)&&(identical(other.cropWidth, cropWidth) || other.cropWidth == cropWidth)&&(identical(other.cropHeight, cropHeight) || other.cropHeight == cropHeight)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.volume, volume) || other.volume == volume));
}


@override
int get hashCode => Object.hash(runtimeType,id,filePath,fileName,totalDuration,trimStart,trimEnd,cropX,cropY,cropWidth,cropHeight,speed,volume);

@override
String toString() {
  return 'VideoClipData(id: $id, filePath: $filePath, fileName: $fileName, totalDuration: $totalDuration, trimStart: $trimStart, trimEnd: $trimEnd, cropX: $cropX, cropY: $cropY, cropWidth: $cropWidth, cropHeight: $cropHeight, speed: $speed, volume: $volume)';
}


}

/// @nodoc
abstract mixin class _$VideoClipDataCopyWith<$Res> implements $VideoClipDataCopyWith<$Res> {
  factory _$VideoClipDataCopyWith(_VideoClipData value, $Res Function(_VideoClipData) _then) = __$VideoClipDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String filePath, String fileName, Duration totalDuration, Duration trimStart, Duration? trimEnd, double cropX, double cropY, double cropWidth, double cropHeight, double speed, double volume
});




}
/// @nodoc
class __$VideoClipDataCopyWithImpl<$Res>
    implements _$VideoClipDataCopyWith<$Res> {
  __$VideoClipDataCopyWithImpl(this._self, this._then);

  final _VideoClipData _self;
  final $Res Function(_VideoClipData) _then;

/// Create a copy of VideoClipData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? filePath = null,Object? fileName = null,Object? totalDuration = null,Object? trimStart = null,Object? trimEnd = freezed,Object? cropX = null,Object? cropY = null,Object? cropWidth = null,Object? cropHeight = null,Object? speed = null,Object? volume = null,}) {
  return _then(_VideoClipData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,trimStart: null == trimStart ? _self.trimStart : trimStart // ignore: cast_nullable_to_non_nullable
as Duration,trimEnd: freezed == trimEnd ? _self.trimEnd : trimEnd // ignore: cast_nullable_to_non_nullable
as Duration?,cropX: null == cropX ? _self.cropX : cropX // ignore: cast_nullable_to_non_nullable
as double,cropY: null == cropY ? _self.cropY : cropY // ignore: cast_nullable_to_non_nullable
as double,cropWidth: null == cropWidth ? _self.cropWidth : cropWidth // ignore: cast_nullable_to_non_nullable
as double,cropHeight: null == cropHeight ? _self.cropHeight : cropHeight // ignore: cast_nullable_to_non_nullable
as double,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$IncidentReport {

 String get monitorCode; String get caseName; String get incidentTime; String get incidentDetails; bool get includeIntro; bool get includeOutro;
/// Create a copy of IncidentReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncidentReportCopyWith<IncidentReport> get copyWith => _$IncidentReportCopyWithImpl<IncidentReport>(this as IncidentReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncidentReport&&(identical(other.monitorCode, monitorCode) || other.monitorCode == monitorCode)&&(identical(other.caseName, caseName) || other.caseName == caseName)&&(identical(other.incidentTime, incidentTime) || other.incidentTime == incidentTime)&&(identical(other.incidentDetails, incidentDetails) || other.incidentDetails == incidentDetails)&&(identical(other.includeIntro, includeIntro) || other.includeIntro == includeIntro)&&(identical(other.includeOutro, includeOutro) || other.includeOutro == includeOutro));
}


@override
int get hashCode => Object.hash(runtimeType,monitorCode,caseName,incidentTime,incidentDetails,includeIntro,includeOutro);

@override
String toString() {
  return 'IncidentReport(monitorCode: $monitorCode, caseName: $caseName, incidentTime: $incidentTime, incidentDetails: $incidentDetails, includeIntro: $includeIntro, includeOutro: $includeOutro)';
}


}

/// @nodoc
abstract mixin class $IncidentReportCopyWith<$Res>  {
  factory $IncidentReportCopyWith(IncidentReport value, $Res Function(IncidentReport) _then) = _$IncidentReportCopyWithImpl;
@useResult
$Res call({
 String monitorCode, String caseName, String incidentTime, String incidentDetails, bool includeIntro, bool includeOutro
});




}
/// @nodoc
class _$IncidentReportCopyWithImpl<$Res>
    implements $IncidentReportCopyWith<$Res> {
  _$IncidentReportCopyWithImpl(this._self, this._then);

  final IncidentReport _self;
  final $Res Function(IncidentReport) _then;

/// Create a copy of IncidentReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monitorCode = null,Object? caseName = null,Object? incidentTime = null,Object? incidentDetails = null,Object? includeIntro = null,Object? includeOutro = null,}) {
  return _then(_self.copyWith(
monitorCode: null == monitorCode ? _self.monitorCode : monitorCode // ignore: cast_nullable_to_non_nullable
as String,caseName: null == caseName ? _self.caseName : caseName // ignore: cast_nullable_to_non_nullable
as String,incidentTime: null == incidentTime ? _self.incidentTime : incidentTime // ignore: cast_nullable_to_non_nullable
as String,incidentDetails: null == incidentDetails ? _self.incidentDetails : incidentDetails // ignore: cast_nullable_to_non_nullable
as String,includeIntro: null == includeIntro ? _self.includeIntro : includeIntro // ignore: cast_nullable_to_non_nullable
as bool,includeOutro: null == includeOutro ? _self.includeOutro : includeOutro // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [IncidentReport].
extension IncidentReportPatterns on IncidentReport {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncidentReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncidentReport() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncidentReport value)  $default,){
final _that = this;
switch (_that) {
case _IncidentReport():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncidentReport value)?  $default,){
final _that = this;
switch (_that) {
case _IncidentReport() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String monitorCode,  String caseName,  String incidentTime,  String incidentDetails,  bool includeIntro,  bool includeOutro)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncidentReport() when $default != null:
return $default(_that.monitorCode,_that.caseName,_that.incidentTime,_that.incidentDetails,_that.includeIntro,_that.includeOutro);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String monitorCode,  String caseName,  String incidentTime,  String incidentDetails,  bool includeIntro,  bool includeOutro)  $default,) {final _that = this;
switch (_that) {
case _IncidentReport():
return $default(_that.monitorCode,_that.caseName,_that.incidentTime,_that.incidentDetails,_that.includeIntro,_that.includeOutro);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String monitorCode,  String caseName,  String incidentTime,  String incidentDetails,  bool includeIntro,  bool includeOutro)?  $default,) {final _that = this;
switch (_that) {
case _IncidentReport() when $default != null:
return $default(_that.monitorCode,_that.caseName,_that.incidentTime,_that.incidentDetails,_that.includeIntro,_that.includeOutro);case _:
  return null;

}
}

}

/// @nodoc


class _IncidentReport implements IncidentReport {
  const _IncidentReport({this.monitorCode = '', this.caseName = '', this.incidentTime = '', this.incidentDetails = '', this.includeIntro = true, this.includeOutro = true});
  

@override@JsonKey() final  String monitorCode;
@override@JsonKey() final  String caseName;
@override@JsonKey() final  String incidentTime;
@override@JsonKey() final  String incidentDetails;
@override@JsonKey() final  bool includeIntro;
@override@JsonKey() final  bool includeOutro;

/// Create a copy of IncidentReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncidentReportCopyWith<_IncidentReport> get copyWith => __$IncidentReportCopyWithImpl<_IncidentReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncidentReport&&(identical(other.monitorCode, monitorCode) || other.monitorCode == monitorCode)&&(identical(other.caseName, caseName) || other.caseName == caseName)&&(identical(other.incidentTime, incidentTime) || other.incidentTime == incidentTime)&&(identical(other.incidentDetails, incidentDetails) || other.incidentDetails == incidentDetails)&&(identical(other.includeIntro, includeIntro) || other.includeIntro == includeIntro)&&(identical(other.includeOutro, includeOutro) || other.includeOutro == includeOutro));
}


@override
int get hashCode => Object.hash(runtimeType,monitorCode,caseName,incidentTime,incidentDetails,includeIntro,includeOutro);

@override
String toString() {
  return 'IncidentReport(monitorCode: $monitorCode, caseName: $caseName, incidentTime: $incidentTime, incidentDetails: $incidentDetails, includeIntro: $includeIntro, includeOutro: $includeOutro)';
}


}

/// @nodoc
abstract mixin class _$IncidentReportCopyWith<$Res> implements $IncidentReportCopyWith<$Res> {
  factory _$IncidentReportCopyWith(_IncidentReport value, $Res Function(_IncidentReport) _then) = __$IncidentReportCopyWithImpl;
@override @useResult
$Res call({
 String monitorCode, String caseName, String incidentTime, String incidentDetails, bool includeIntro, bool includeOutro
});




}
/// @nodoc
class __$IncidentReportCopyWithImpl<$Res>
    implements _$IncidentReportCopyWith<$Res> {
  __$IncidentReportCopyWithImpl(this._self, this._then);

  final _IncidentReport _self;
  final $Res Function(_IncidentReport) _then;

/// Create a copy of IncidentReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monitorCode = null,Object? caseName = null,Object? incidentTime = null,Object? incidentDetails = null,Object? includeIntro = null,Object? includeOutro = null,}) {
  return _then(_IncidentReport(
monitorCode: null == monitorCode ? _self.monitorCode : monitorCode // ignore: cast_nullable_to_non_nullable
as String,caseName: null == caseName ? _self.caseName : caseName // ignore: cast_nullable_to_non_nullable
as String,incidentTime: null == incidentTime ? _self.incidentTime : incidentTime // ignore: cast_nullable_to_non_nullable
as String,incidentDetails: null == incidentDetails ? _self.incidentDetails : incidentDetails // ignore: cast_nullable_to_non_nullable
as String,includeIntro: null == includeIntro ? _self.includeIntro : includeIntro // ignore: cast_nullable_to_non_nullable
as bool,includeOutro: null == includeOutro ? _self.includeOutro : includeOutro // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$EditorState {

 List<VideoClipData> get clips; int get activeClipIndex; bool get includeIntro; bool get includeOutro; bool get isCropMode; bool get isExporting; double get exportProgress; String get exportStatusMessage; bool get showOutroPreview; IncidentReport? get incidentReport;
/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditorStateCopyWith<EditorState> get copyWith => _$EditorStateCopyWithImpl<EditorState>(this as EditorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditorState&&const DeepCollectionEquality().equals(other.clips, clips)&&(identical(other.activeClipIndex, activeClipIndex) || other.activeClipIndex == activeClipIndex)&&(identical(other.includeIntro, includeIntro) || other.includeIntro == includeIntro)&&(identical(other.includeOutro, includeOutro) || other.includeOutro == includeOutro)&&(identical(other.isCropMode, isCropMode) || other.isCropMode == isCropMode)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.exportProgress, exportProgress) || other.exportProgress == exportProgress)&&(identical(other.exportStatusMessage, exportStatusMessage) || other.exportStatusMessage == exportStatusMessage)&&(identical(other.showOutroPreview, showOutroPreview) || other.showOutroPreview == showOutroPreview)&&(identical(other.incidentReport, incidentReport) || other.incidentReport == incidentReport));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(clips),activeClipIndex,includeIntro,includeOutro,isCropMode,isExporting,exportProgress,exportStatusMessage,showOutroPreview,incidentReport);

@override
String toString() {
  return 'EditorState(clips: $clips, activeClipIndex: $activeClipIndex, includeIntro: $includeIntro, includeOutro: $includeOutro, isCropMode: $isCropMode, isExporting: $isExporting, exportProgress: $exportProgress, exportStatusMessage: $exportStatusMessage, showOutroPreview: $showOutroPreview, incidentReport: $incidentReport)';
}


}

/// @nodoc
abstract mixin class $EditorStateCopyWith<$Res>  {
  factory $EditorStateCopyWith(EditorState value, $Res Function(EditorState) _then) = _$EditorStateCopyWithImpl;
@useResult
$Res call({
 List<VideoClipData> clips, int activeClipIndex, bool includeIntro, bool includeOutro, bool isCropMode, bool isExporting, double exportProgress, String exportStatusMessage, bool showOutroPreview, IncidentReport? incidentReport
});


$IncidentReportCopyWith<$Res>? get incidentReport;

}
/// @nodoc
class _$EditorStateCopyWithImpl<$Res>
    implements $EditorStateCopyWith<$Res> {
  _$EditorStateCopyWithImpl(this._self, this._then);

  final EditorState _self;
  final $Res Function(EditorState) _then;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clips = null,Object? activeClipIndex = null,Object? includeIntro = null,Object? includeOutro = null,Object? isCropMode = null,Object? isExporting = null,Object? exportProgress = null,Object? exportStatusMessage = null,Object? showOutroPreview = null,Object? incidentReport = freezed,}) {
  return _then(_self.copyWith(
clips: null == clips ? _self.clips : clips // ignore: cast_nullable_to_non_nullable
as List<VideoClipData>,activeClipIndex: null == activeClipIndex ? _self.activeClipIndex : activeClipIndex // ignore: cast_nullable_to_non_nullable
as int,includeIntro: null == includeIntro ? _self.includeIntro : includeIntro // ignore: cast_nullable_to_non_nullable
as bool,includeOutro: null == includeOutro ? _self.includeOutro : includeOutro // ignore: cast_nullable_to_non_nullable
as bool,isCropMode: null == isCropMode ? _self.isCropMode : isCropMode // ignore: cast_nullable_to_non_nullable
as bool,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,exportProgress: null == exportProgress ? _self.exportProgress : exportProgress // ignore: cast_nullable_to_non_nullable
as double,exportStatusMessage: null == exportStatusMessage ? _self.exportStatusMessage : exportStatusMessage // ignore: cast_nullable_to_non_nullable
as String,showOutroPreview: null == showOutroPreview ? _self.showOutroPreview : showOutroPreview // ignore: cast_nullable_to_non_nullable
as bool,incidentReport: freezed == incidentReport ? _self.incidentReport : incidentReport // ignore: cast_nullable_to_non_nullable
as IncidentReport?,
  ));
}
/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IncidentReportCopyWith<$Res>? get incidentReport {
    if (_self.incidentReport == null) {
    return null;
  }

  return $IncidentReportCopyWith<$Res>(_self.incidentReport!, (value) {
    return _then(_self.copyWith(incidentReport: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditorState].
extension EditorStatePatterns on EditorState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditorState value)  $default,){
final _that = this;
switch (_that) {
case _EditorState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditorState value)?  $default,){
final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<VideoClipData> clips,  int activeClipIndex,  bool includeIntro,  bool includeOutro,  bool isCropMode,  bool isExporting,  double exportProgress,  String exportStatusMessage,  bool showOutroPreview,  IncidentReport? incidentReport)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that.clips,_that.activeClipIndex,_that.includeIntro,_that.includeOutro,_that.isCropMode,_that.isExporting,_that.exportProgress,_that.exportStatusMessage,_that.showOutroPreview,_that.incidentReport);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<VideoClipData> clips,  int activeClipIndex,  bool includeIntro,  bool includeOutro,  bool isCropMode,  bool isExporting,  double exportProgress,  String exportStatusMessage,  bool showOutroPreview,  IncidentReport? incidentReport)  $default,) {final _that = this;
switch (_that) {
case _EditorState():
return $default(_that.clips,_that.activeClipIndex,_that.includeIntro,_that.includeOutro,_that.isCropMode,_that.isExporting,_that.exportProgress,_that.exportStatusMessage,_that.showOutroPreview,_that.incidentReport);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<VideoClipData> clips,  int activeClipIndex,  bool includeIntro,  bool includeOutro,  bool isCropMode,  bool isExporting,  double exportProgress,  String exportStatusMessage,  bool showOutroPreview,  IncidentReport? incidentReport)?  $default,) {final _that = this;
switch (_that) {
case _EditorState() when $default != null:
return $default(_that.clips,_that.activeClipIndex,_that.includeIntro,_that.includeOutro,_that.isCropMode,_that.isExporting,_that.exportProgress,_that.exportStatusMessage,_that.showOutroPreview,_that.incidentReport);case _:
  return null;

}
}

}

/// @nodoc


class _EditorState implements EditorState {
  const _EditorState({final  List<VideoClipData> clips = const [], this.activeClipIndex = -1, this.includeIntro = true, this.includeOutro = true, this.isCropMode = false, this.isExporting = false, this.exportProgress = 0.0, this.exportStatusMessage = '', this.showOutroPreview = false, this.incidentReport}): _clips = clips;
  

 final  List<VideoClipData> _clips;
@override@JsonKey() List<VideoClipData> get clips {
  if (_clips is EqualUnmodifiableListView) return _clips;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_clips);
}

@override@JsonKey() final  int activeClipIndex;
@override@JsonKey() final  bool includeIntro;
@override@JsonKey() final  bool includeOutro;
@override@JsonKey() final  bool isCropMode;
@override@JsonKey() final  bool isExporting;
@override@JsonKey() final  double exportProgress;
@override@JsonKey() final  String exportStatusMessage;
@override@JsonKey() final  bool showOutroPreview;
@override final  IncidentReport? incidentReport;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditorStateCopyWith<_EditorState> get copyWith => __$EditorStateCopyWithImpl<_EditorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditorState&&const DeepCollectionEquality().equals(other._clips, _clips)&&(identical(other.activeClipIndex, activeClipIndex) || other.activeClipIndex == activeClipIndex)&&(identical(other.includeIntro, includeIntro) || other.includeIntro == includeIntro)&&(identical(other.includeOutro, includeOutro) || other.includeOutro == includeOutro)&&(identical(other.isCropMode, isCropMode) || other.isCropMode == isCropMode)&&(identical(other.isExporting, isExporting) || other.isExporting == isExporting)&&(identical(other.exportProgress, exportProgress) || other.exportProgress == exportProgress)&&(identical(other.exportStatusMessage, exportStatusMessage) || other.exportStatusMessage == exportStatusMessage)&&(identical(other.showOutroPreview, showOutroPreview) || other.showOutroPreview == showOutroPreview)&&(identical(other.incidentReport, incidentReport) || other.incidentReport == incidentReport));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_clips),activeClipIndex,includeIntro,includeOutro,isCropMode,isExporting,exportProgress,exportStatusMessage,showOutroPreview,incidentReport);

@override
String toString() {
  return 'EditorState(clips: $clips, activeClipIndex: $activeClipIndex, includeIntro: $includeIntro, includeOutro: $includeOutro, isCropMode: $isCropMode, isExporting: $isExporting, exportProgress: $exportProgress, exportStatusMessage: $exportStatusMessage, showOutroPreview: $showOutroPreview, incidentReport: $incidentReport)';
}


}

/// @nodoc
abstract mixin class _$EditorStateCopyWith<$Res> implements $EditorStateCopyWith<$Res> {
  factory _$EditorStateCopyWith(_EditorState value, $Res Function(_EditorState) _then) = __$EditorStateCopyWithImpl;
@override @useResult
$Res call({
 List<VideoClipData> clips, int activeClipIndex, bool includeIntro, bool includeOutro, bool isCropMode, bool isExporting, double exportProgress, String exportStatusMessage, bool showOutroPreview, IncidentReport? incidentReport
});


@override $IncidentReportCopyWith<$Res>? get incidentReport;

}
/// @nodoc
class __$EditorStateCopyWithImpl<$Res>
    implements _$EditorStateCopyWith<$Res> {
  __$EditorStateCopyWithImpl(this._self, this._then);

  final _EditorState _self;
  final $Res Function(_EditorState) _then;

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clips = null,Object? activeClipIndex = null,Object? includeIntro = null,Object? includeOutro = null,Object? isCropMode = null,Object? isExporting = null,Object? exportProgress = null,Object? exportStatusMessage = null,Object? showOutroPreview = null,Object? incidentReport = freezed,}) {
  return _then(_EditorState(
clips: null == clips ? _self._clips : clips // ignore: cast_nullable_to_non_nullable
as List<VideoClipData>,activeClipIndex: null == activeClipIndex ? _self.activeClipIndex : activeClipIndex // ignore: cast_nullable_to_non_nullable
as int,includeIntro: null == includeIntro ? _self.includeIntro : includeIntro // ignore: cast_nullable_to_non_nullable
as bool,includeOutro: null == includeOutro ? _self.includeOutro : includeOutro // ignore: cast_nullable_to_non_nullable
as bool,isCropMode: null == isCropMode ? _self.isCropMode : isCropMode // ignore: cast_nullable_to_non_nullable
as bool,isExporting: null == isExporting ? _self.isExporting : isExporting // ignore: cast_nullable_to_non_nullable
as bool,exportProgress: null == exportProgress ? _self.exportProgress : exportProgress // ignore: cast_nullable_to_non_nullable
as double,exportStatusMessage: null == exportStatusMessage ? _self.exportStatusMessage : exportStatusMessage // ignore: cast_nullable_to_non_nullable
as String,showOutroPreview: null == showOutroPreview ? _self.showOutroPreview : showOutroPreview // ignore: cast_nullable_to_non_nullable
as bool,incidentReport: freezed == incidentReport ? _self.incidentReport : incidentReport // ignore: cast_nullable_to_non_nullable
as IncidentReport?,
  ));
}

/// Create a copy of EditorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IncidentReportCopyWith<$Res>? get incidentReport {
    if (_self.incidentReport == null) {
    return null;
  }

  return $IncidentReportCopyWith<$Res>(_self.incidentReport!, (value) {
    return _then(_self.copyWith(incidentReport: value));
  });
}
}

// dart format on
