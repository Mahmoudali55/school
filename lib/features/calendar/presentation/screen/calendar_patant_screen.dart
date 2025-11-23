import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

class CalendarPatentScreen extends StatefulWidget {
  const CalendarPatentScreen({super.key});

  @override
  State<CalendarPatentScreen> createState() => _CalendarPatentScreenState();
}

class _CalendarPatentScreenState extends State<CalendarPatentScreen> {
  DateTime _selectedDate = DateTime.now();
  int _currentView = 0; // 0: شهري, 1: أسبوعي, 2: يومي
  String _selectedStudent = "أحمد"; // الطالب المختار
  List<String> _students = ["أحمد", "ليلى", "محمد"]; // قائمة الأبناء

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // رأس الصفحة
            _buildHeader(),
            // اختيار الطالب وشريط التحكم
            _buildControlBar(),
            // عرض التقويم
            Expanded(child: _buildCalendarContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تقويم المتابعة",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                _getFormattedDate(_selectedDate),
                style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.family_restroom_rounded, color: const Color(0xFF2196F3), size: 24.w),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: Colors.white,
      child: Column(
        children: [
          // اختيار الطالب
          _buildStudentSelector(),
          SizedBox(height: 12.h),
          // شريط العرض والتنقل
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildViewButton("شهري", 0),
                      _buildViewButton("أسبوعي", 1),
                      _buildViewButton("يومي", 2),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_right_rounded, size: 20.w),
                      onPressed: _goToPrevious,
                    ),
                    Container(
                      width: 1.w,
                      height: 20.h,
                      color: const Color(0xFF2196F3).withOpacity(0.3),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_left_rounded, size: 20.w),
                      onPressed: _goToNext,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStudent,
          icon: Icon(Icons.arrow_drop_down_rounded, color: const Color(0xFF2196F3)),
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedStudent = newValue!;
            });
          },
          items: _students.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(Icons.person_outline_rounded, size: 16.w, color: const Color(0xFF2196F3)),
                  SizedBox(width: 6.w),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildViewButton(String text, int index) {
    bool isSelected = _currentView == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentView = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2196F3) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarContent() {
    switch (_currentView) {
      case 0:
        return _buildMonthlyView();
      case 1:
        return _buildWeeklyView();
      case 2:
        return _buildDailyView();
      default:
        return _buildMonthlyView();
    }
  }

  Widget _buildMonthlyView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // رأس الأيام
          _buildDaysHeader(),
          SizedBox(height: 8.h),
          // شبكة الأيام
          _buildMonthGrid(),
          SizedBox(height: 20.h),
          // ملخص الشهر
          _buildMonthlySummary(),
          SizedBox(height: 20.h),
          // الأحداث القادمة
          _buildUpcomingEvents(),
        ],
      ),
    );
  }

  Widget _buildDaysHeader() {
    List<String> days = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];

    return Row(
      children: days
          .map(
            (day) => Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2196F3),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMonthGrid() {
    DateTime firstDay = DateTime(_selectedDate.year, _selectedDate.month, 1);
    int startingWeekday = firstDay.weekday % 7;
    int daysInMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
        childAspectRatio: 1.2,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        int dayNumber = index - startingWeekday + 1;
        bool isCurrentMonth = dayNumber > 0 && dayNumber <= daysInMonth;
        bool isToday =
            isCurrentMonth &&
            dayNumber == DateTime.now().day &&
            _selectedDate.month == DateTime.now().month &&
            _selectedDate.year == DateTime.now().year;
        bool isSelected = isCurrentMonth && dayNumber == _selectedDate.day;

        if (!isCurrentMonth) {
          return Container();
        }

        List<ParentCalendarEvent> dayEvents = _getEventsForDay(
          DateTime(_selectedDate.year, _selectedDate.month, dayNumber),
        );

        return GestureDetector(
          onTap: () => setState(() {
            _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, dayNumber);
          }),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2196F3)
                  : isToday
                  ? const Color(0xFF2196F3).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isToday ? const Color(0xFF2196F3) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                if (dayEvents.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...dayEvents
                          .take(2)
                          .map(
                            (event) => Container(
                              width: 4.w,
                              height: 4.w,
                              margin: EdgeInsets.symmetric(horizontal: 1.w),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : event.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      if (dayEvents.length > 2)
                        Text(
                          '+${dayEvents.length - 2}',
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: isSelected ? Colors.white : const Color(0xFF6B7280),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthlySummary() {
    List<ParentCalendarEvent> monthEvents = _getEventsForMonth(_selectedDate);

    Map<String, int> eventCounts = {};
    for (var event in monthEvents) {
      eventCounts[event.type] = (eventCounts[event.type] ?? 0) + 1;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ملخص الشهر",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem("امتحانات", eventCounts["امتحان"] ?? 0, Color(0xFFDC2626)),
              _buildSummaryItem("فعاليات", eventCounts["فعالية"] ?? 0, Color(0xFF10B981)),
              _buildSummaryItem("اجتماعات", eventCounts["اجتماع"] ?? 0, Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Text(
            '$count',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: color),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildWeeklyView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildWeekDays(),
          SizedBox(height: 20.h),
          _buildChildrenSchedule(),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    DateTime startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));

    return Column(
      children: List.generate(7, (index) {
        DateTime day = startOfWeek.add(Duration(days: index));
        List<ParentCalendarEvent> dayEvents = _getEventsForDay(day);
        bool isToday = _isSameDay(day, DateTime.now());
        bool isSelected = _isSameDay(day, _selectedDate);

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = day),
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2196F3)
                    : isToday
                    ? const Color(0xFF2196F3).withOpacity(0.3)
                    : Colors.transparent,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        _getDayName(day.weekday),
                        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dayEvents
                        .take(2)
                        .map(
                          (event) => Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration: BoxDecoration(
                                    color: event.color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.person_rounded, size: 8.w, color: Colors.white),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    event.title,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF1F2937),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  event.time,
                                  style: TextStyle(fontSize: 10.sp, color: const Color(0xFF6B7280)),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (dayEvents.length > 2)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '+${dayEvents.length - 2}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFF2196F3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildChildrenSchedule() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "جدول الأبناء هذا الأسبوع",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "3 أبناء",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF2196F3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Column(children: _students.map((student) => _buildChildSchedule(student)).toList()),
        ],
      ),
    );
  }

  Widget _buildChildSchedule(String studentName) {
    List<ParentCalendarEvent> studentEvents = _getEventsForStudent(studentName);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_rounded, size: 14.w, color: const Color(0xFF2196F3)),
              ),
              SizedBox(width: 8.w),
              Text(
                studentName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "${studentEvents.length} حدث",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (studentEvents.isEmpty)
            _buildEmptySchedule()
          else
            Column(
              children: studentEvents.take(3).map((event) => _buildScheduleItem(event)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(ParentCalendarEvent event) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: event.color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${event.date} • ${event.time}",
                  style: TextStyle(fontSize: 10.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              event.type,
              style: TextStyle(fontSize: 9.sp, color: event.color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySchedule() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Icon(Icons.event_busy_rounded, size: 16.w, color: const Color(0xFF9CA3AF)),
          SizedBox(width: 8.w),
          Text(
            "لا توجد أحداث هذا الأسبوع",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyView() {
    List<ParentCalendarEvent> dailyEvents = _getEventsForDay(_selectedDate);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // تاريخ اليوم
          _buildDailyHeader(dailyEvents.length),
          SizedBox(height: 16.h),
          // قائمة الأحداث
          if (dailyEvents.isEmpty)
            _buildEmptyState()
          else
            Column(children: dailyEvents.map((event) => _buildEventCard(event)).toList()),
          SizedBox(height: 20.h),
          // ملاحظات اليوم
          _buildDailyNotes(),
        ],
      ),
    );
  }

  Widget _buildDailyHeader(int eventCount) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.today_rounded, color: const Color(0xFF2196F3), size: 20.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFormattedDate(_selectedDate),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _getDayName(_selectedDate.weekday),
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$eventCount حدث",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF2196F3),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "لـ ${_students.length} أبناء",
                style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(ParentCalendarEvent event) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: event.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 14.w,
                            color: const Color(0xFF2196F3),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          event.student,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2196F3),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 14.w, color: const Color(0xFF6B7280)),
                        SizedBox(width: 4.w),
                        Text(
                          event.time,
                          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                        ),
                        SizedBox(width: 16.w),
                        Icon(Icons.location_on_rounded, size: 14.w, color: const Color(0xFF6B7280)),
                        SizedBox(width: 4.w),
                        Text(
                          event.location,
                          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                    if (event.description.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Text(
                        event.description,
                        style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: event.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  event.type,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: event.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // إجراءات سريعة
          if (event.type == "امتحان" || event.type == "فعالية") _buildEventActions(event),
        ],
      ),
    );
  }

  Widget _buildEventActions(ParentCalendarEvent event) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.notifications_none_rounded, size: 16.w),
            label: Text("تذكير"),
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2196F3),
              side: BorderSide(color: const Color(0xFF2196F3).withOpacity(0.3)),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(Icons.share_rounded, size: 16.w),
            label: Text("مشاركة"),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyNotes() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ملاحظات اليوم",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_rounded, size: 20.w),
                onPressed: () {},
                color: const Color(0xFF2196F3),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          TextField(
            decoration: InputDecoration(
              hintText: "أضف ملاحظة حول اليوم...",
              hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
              border: InputBorder.none,
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    List<ParentCalendarEvent> upcomingEvents = _getUpcomingEvents();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "الأحداث القادمة",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            Text(
              "عرض الكل",
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF2196F3),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (upcomingEvents.isEmpty)
          _buildEmptyState()
        else
          Column(
            children: upcomingEvents
                .take(5)
                .map((event) => _buildUpcomingEventItem(event))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildUpcomingEventItem(ParentCalendarEvent event) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: event.color, shape: BoxShape.circle),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      event.student,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF2196F3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  "${event.date} • ${event.time}",
                  style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              event.type,
              style: TextStyle(fontSize: 9.sp, color: event.color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(Icons.family_restroom_rounded, size: 48.w, color: const Color(0xFF9CA3AF)),
          SizedBox(height: 12.h),
          Text(
            "لا توجد أحداث",
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "لا توجد أحداث مخططة لهذا اليوم",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  // الدوال المساعدة
  void _goToPrevious() {
    setState(() {
      if (_currentView == 0) {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
      } else if (_currentView == 1) {
        _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      } else {
        _selectedDate = _selectedDate.subtract(const Duration(days: 1));
      }
    });
  }

  void _goToNext() {
    setState(() {
      if (_currentView == 0) {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
      } else if (_currentView == 1) {
        _selectedDate = _selectedDate.add(const Duration(days: 7));
      } else {
        _selectedDate = _selectedDate.add(const Duration(days: 1));
      }
    });
  }

  String _getFormattedDate(DateTime date) {
    List<String> months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getDayName(int weekday) {
    List<String> days = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
    return days[weekday % 7];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // بيانات تجريبية للأحداث
  List<ParentCalendarEvent> _getEventsForDay(DateTime day) {
    List<ParentCalendarEvent> allEvents = [
      ParentCalendarEvent(
        title: "اختبار الرياضيات",
        date: "١٥ نوفمبر",
        time: "٨:٠٠ ص - ٩:٣٠ ص",
        type: "امتحان",
        color: Color(0xFFDC2626),
        location: "القاعة ١٠١",
        description: "الوحدة الثالثة - الجبر",
        student: "أحمد",
      ),
      ParentCalendarEvent(
        title: "حفل التكريم",
        date: "١٥ نوفمبر",
        time: "١٠:٠٠ ص - ١١:٠٠ ص",
        type: "فعالية",
        color: Color(0xFF10B981),
        location: "الساحة الرئيسية",
        description: "تكريم الطلاب المتفوقين",
        student: "ليلى",
      ),
      ParentCalendarEvent(
        title: "اجتماع أولياء الأمور",
        date: "١٨ نوفمبر",
        time: "١:٠٠ م - ٢:٠٠ م",
        type: "اجتماع",
        color: Color(0xFFF59E0B),
        location: "قاعة الاجتماعات",
        description: "مناقشة المستوى الدراسي",
        student: "جميع الأبناء",
      ),
      ParentCalendarEvent(
        title: "رحلة علمية",
        date: "٢٠ نوفمبر",
        time: "٨:٠٠ ص - ١٢:٠٠ م",
        type: "نشاط",
        color: Color(0xFF7C3AED),
        location: "متحف العلوم",
        description: "زيارة إلى متحف العلوم الوطني",
        student: "محمد",
      ),
    ];

    return allEvents.where((event) => event.date.contains('${day.day}')).toList();
  }

  List<ParentCalendarEvent> _getEventsForMonth(DateTime month) {
    // ترجع جميع أحداث الشهر
    return _getEventsForDay(month);
  }

  List<ParentCalendarEvent> _getEventsForStudent(String student) {
    // ترجع أحداث طالب معين
    return _getEventsForDay(
      _selectedDate,
    ).where((event) => event.student == student || event.student == "جميع الأبناء").toList();
  }

  List<ParentCalendarEvent> _getUpcomingEvents() {
    // ترجع الأحداث القادمة في الأيام التالية
    return _getEventsForDay(_selectedDate);
  }
}

class ParentCalendarEvent {
  final String title;
  final String date;
  final String time;
  final String type;
  final Color color;
  final String location;
  final String description;
  final String student;

  ParentCalendarEvent({
    required this.title,
    required this.date,
    required this.time,
    required this.type,
    required this.color,
    required this.location,
    required this.description,
    required this.student,
  });
}
