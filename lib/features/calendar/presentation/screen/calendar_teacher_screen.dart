import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

class CalendarTeacherScreen extends StatefulWidget {
  const CalendarTeacherScreen({super.key});

  @override
  State<CalendarTeacherScreen> createState() => _CalendarTeacherScreenState();
}

class _CalendarTeacherScreenState extends State<CalendarTeacherScreen> {
  DateTime _selectedDate = DateTime.now();
  int _currentView = 0; // 0: شهري, 1: أسبوعي, 2: يومي
  String _selectedClass = "الصف العاشر - علمي"; // الصف المختار
  List<String> _classes = ["الصف العاشر - علمي", "الصف التاسع - أدبي", "الصف الحادي عشر - علمي"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // رأس الصفحة
            _buildHeader(),
            // اختيار الصف وشريط التحكم
            _buildControlBar(),
            // عرض التقويم
            Expanded(child: _buildCalendarContent()),
          ],
        ),
      ),
      // زر إضافة حدث جديد
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEvent,
        backgroundColor: const Color(0xFFFF9800),
        foregroundColor: Colors.white,
        child: Icon(Icons.add_rounded, size: 24.w),
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
                "التقويم التدريسي",
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
              color: const Color(0xFFFF9800).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.school_rounded, color: const Color(0xFFFF9800), size: 24.w),
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
          // اختيار الصف
          _buildClassSelector(),
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
                  color: const Color(0xFFFF9800).withOpacity(0.1),
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
                      color: const Color(0xFFFF9800).withOpacity(0.3),
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

  Widget _buildClassSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedClass,
          icon: Icon(Icons.arrow_drop_down_rounded, color: const Color(0xFFFF9800)),
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedClass = newValue!;
            });
          },
          items: _classes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(Icons.class_rounded, size: 16.w, color: const Color(0xFFFF9800)),
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
            color: isSelected ? const Color(0xFFFF9800) : Colors.transparent,
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
          // إحصائيات الشهر
          _buildMonthlyStats(),
          SizedBox(height: 20.h),
          // المهام القادمة
          _buildUpcomingTasks(),
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
                    color: const Color(0xFFFF9800),
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

        List<TeacherCalendarEvent> dayEvents = _getEventsForDay(
          DateTime(_selectedDate.year, _selectedDate.month, dayNumber),
        );

        return GestureDetector(
          onTap: () => setState(() {
            _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, dayNumber);
          }),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFFF9800)
                  : isToday
                  ? const Color(0xFFFF9800).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isToday ? const Color(0xFFFF9800) : Colors.transparent,
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

  Widget _buildMonthlyStats() {
    List<TeacherCalendarEvent> monthEvents = _getEventsForMonth(_selectedDate);

    int classesCount = monthEvents.where((event) => event.type == "حصّة").length;
    int examsCount = monthEvents.where((event) => event.type == "امتحان").length;
    int meetingsCount = monthEvents.where((event) => event.type == "اجتماع").length;

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
            "إحصائيات الشهر",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("حصص", classesCount, Color(0xFFFF9800), Icons.school_rounded),
              _buildStatItem("امتحانات", examsCount, Color(0xFFDC2626), Icons.assignment_rounded),
              _buildStatItem("اجتماعات", meetingsCount, Color(0xFF10B981), Icons.groups_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, int count, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, size: 18.w, color: color),
        ),
        SizedBox(height: 6.h),
        Text(
          '$count',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 2.h),
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
          _buildWeekTimetable(),
          SizedBox(height: 20.h),
          _buildWeeklyTasks(),
        ],
      ),
    );
  }

  Widget _buildWeekTimetable() {
    DateTime startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));

    return Container(
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
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "الجدول الأسبوعي",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _selectedClass,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFFFF9800),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // رأس الجدول
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              border: Border(
                top: BorderSide(color: const Color(0xFFE5E7EB)),
                bottom: BorderSide(color: const Color(0xFFE5E7EB)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  child: Text(
                    "اليوم/الوقت",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTimeSlot("٨:٠٠"),
                      _buildTimeSlot("٩:٠٠"),
                      _buildTimeSlot("١٠:٠٠"),
                      _buildTimeSlot("١١:٠٠"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // أيام الأسبوع
          Column(
            children: List.generate(5, (index) {
              DateTime day = startOfWeek.add(Duration(days: index));
              return _buildWeekDayRow(day);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    return Container(
      width: 60.w,
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildWeekDayRow(DateTime day) {
    List<TeacherCalendarEvent> dayEvents = _getEventsForDay(day);
    bool isToday = _isSameDay(day, DateTime.now());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDayName(day.weekday),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isToday ? const Color(0xFFFF9800) : const Color(0xFF6B7280),
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildClassSlot(day, "٨:٠٠"),
                _buildClassSlot(day, "٩:٠٠"),
                _buildClassSlot(day, "١٠:٠٠"),
                _buildClassSlot(day, "١١:٠٠"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassSlot(DateTime day, String time) {
    List<TeacherCalendarEvent> slotEvents = _getEventsForTime(day, time);

    if (slotEvents.isEmpty) {
      return Container(
        width: 60.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    TeacherCalendarEvent event = slotEvents.first;

    return Container(
      width: 60.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: event.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: event.color.withOpacity(0.3)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              event.subject,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: event.color),
            ),
            SizedBox(height: 2.h),
            Text(
              event.className,
              style: TextStyle(fontSize: 8.sp, color: const Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyTasks() {
    List<TeacherCalendarEvent> weeklyTasks = _getWeeklyTasks();

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
                "المهام الأسبوعية",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${weeklyTasks.length} مهمة",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Column(children: weeklyTasks.map((task) => _buildTaskItem(task)).toList()),
        ],
      ),
    );
  }

  Widget _buildTaskItem(TeacherCalendarEvent task) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: task.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_getTaskIcon(task.type), size: 16.w, color: task.color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 12.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      "${task.date} • ${task.time}",
                      style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.class_rounded, size: 12.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      task.className,
                      style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: task.status == "مكتمل"
                  ? const Color(0xFF10B981).withOpacity(0.1)
                  : task.status == "متأخر"
                  ? const Color(0xFFDC2626).withOpacity(0.1)
                  : const Color(0xFFFF9800).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              task.status,
              style: TextStyle(
                fontSize: 10.sp,
                color: task.status == "مكتمل"
                    ? const Color(0xFF10B981)
                    : task.status == "متأخر"
                    ? const Color(0xFFDC2626)
                    : const Color(0xFFFF9800),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyView() {
    List<TeacherCalendarEvent> dailyEvents = _getEventsForDay(_selectedDate);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // رأس اليوم
          _buildDailyHeader(dailyEvents.length),
          SizedBox(height: 16.h),
          // الجدول اليومي
          _buildDailyTimetable(),
          SizedBox(height: 20.h),
          // المهام اليومية
          _buildDailyTasks(),
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
              color: const Color(0xFFFF9800).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.today_rounded, color: const Color(0xFFFF9800), size: 20.w),
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
                  color: const Color(0xFFFF9800),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "${_getTeachingHours()} ساعة تدريس",
                style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTimetable() {
    List<TeacherCalendarEvent> dailyClasses = _getDailyClasses();

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
            "الجدول اليومي",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 12.h),
          if (dailyClasses.isEmpty)
            _buildEmptySchedule()
          else
            Column(
              children: dailyClasses.map((classEvent) => _buildClassItem(classEvent)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildClassItem(TeacherCalendarEvent classEvent) {
    bool isCurrent = _isCurrentEvent(classEvent);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFFF9800).withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCurrent ? const Color(0xFFFF9800) : const Color(0xFFE5E7EB),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: classEvent.color,
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
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: classEvent.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        classEvent.time,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: classEvent.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (isCurrent)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "الآن",
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
                Text(
                  classEvent.subject,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.class_rounded, size: 14.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      classEvent.className,
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.location_on_rounded, size: 14.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      classEvent.location,
                      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                    ),
                  ],
                ),
                if (classEvent.description.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    classEvent.description,
                    style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                  ),
                ],
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.notes_rounded, size: 20.w),
                onPressed: () => _showClassNotes(classEvent),
                color: const Color(0xFF6B7280),
              ),
              SizedBox(height: 8.h),
              IconButton(
                icon: Icon(Icons.assignment_rounded, size: 20.w),
                onPressed: () => _showClassMaterials(classEvent),
                color: const Color(0xFF6B7280),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTasks() {
    List<TeacherCalendarEvent> dailyTasks = _getDailyTasks();

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
                "المهام اليومية",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${dailyTasks.where((task) => task.status == "متأخر").length} متأخرة",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFFDC2626),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (dailyTasks.isEmpty)
            _buildEmptyTasks()
          else
            Column(children: dailyTasks.map((task) => _buildDailyTaskItem(task)).toList()),
        ],
      ),
    );
  }

  Widget _buildDailyTaskItem(TeacherCalendarEvent task) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.status == "مكتمل",
            onChanged: (value) {
              _toggleTaskStatus(task);
            },
            activeColor: const Color(0xFF10B981),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                    decoration: task.status == "مكتمل"
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 12.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      task.time,
                      style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.class_rounded, size: 12.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      task.className,
                      style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, size: 18.w, color: const Color(0xFF6B7280)),
            onSelected: (value) => _handleTaskAction(value, task),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'edit', child: Text('تعديل')),
              PopupMenuItem(value: 'delete', child: Text('حذف')),
              PopupMenuItem(value: 'postpone', child: Text('تأجيل')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTasks() {
    List<TeacherCalendarEvent> upcomingTasks = _getUpcomingTasks();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "المهام القادمة",
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
                color: const Color(0xFFFF9800),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (upcomingTasks.isEmpty)
          _buildEmptyTasks()
        else
          Column(
            children: upcomingTasks.take(5).map((task) => _buildUpcomingTaskItem(task)).toList(),
          ),
      ],
    );
  }

  Widget _buildUpcomingTaskItem(TeacherCalendarEvent task) {
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
            decoration: BoxDecoration(color: task.color, shape: BoxShape.circle),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      task.className,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFFFF9800),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "${task.date} • ${task.time}",
                      style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: task.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              task.type,
              style: TextStyle(fontSize: 9.sp, color: task.color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySchedule() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(Icons.school_outlined, size: 48.w, color: const Color(0xFF9CA3AF)),
          SizedBox(height: 12.h),
          Text(
            "لا توجد حصص",
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "لا توجد حصص مخططة لهذا اليوم",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTasks() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 40.w, color: const Color(0xFF9CA3AF)),
          SizedBox(height: 8.h),
          Text(
            "لا توجد مهام",
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // الدوال المساعدة والإجراءات
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

  IconData _getTaskIcon(String type) {
    switch (type) {
      case "تصحيح":
        return Icons.assignment_rounded;
      case "تحضير":
        return Icons.menu_book_rounded;
      case "اجتماع":
        return Icons.groups_rounded;
      case "امتحان":
        return Icons.quiz_rounded;
      default:
        return Icons.task_rounded;
    }
  }

  void _addNewEvent() {
    // تنفيذ إضافة حدث جديد
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("إضافة حدث جديد"),
        content: Text("سيتم فتح نموذج إضافة حدث جديد"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("إلغاء")),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("إضافة")),
        ],
      ),
    );
  }

  void _showClassNotes(TeacherCalendarEvent classEvent) {
    // عرض ملاحظات الحصة
  }

  void _showClassMaterials(TeacherCalendarEvent classEvent) {
    // عرض مواد الحصة
  }

  void _toggleTaskStatus(TeacherCalendarEvent task) {
    // تبديل حالة المهمة
  }

  void _handleTaskAction(String action, TeacherCalendarEvent task) {
    // معالجة إجراءات المهمة
  }

  String _getTeachingHours() {
    // حساب ساعات التدريس
    return "6";
  }

  bool _isCurrentEvent(TeacherCalendarEvent event) {
    // التحقق إذا كان الحدث حالي
    return true;
  }

  // بيانات تجريبية للأحداث
  List<TeacherCalendarEvent> _getEventsForDay(DateTime day) {
    List<TeacherCalendarEvent> allEvents = [
      TeacherCalendarEvent(
        title: "حصّة الرياضيات",
        date: "١٥ نوفمبر",
        time: "٨:٠٠ - ٨:٤٥",
        type: "حصّة",
        color: Color(0xFFFF9800),
        location: "القاعة ١٠١",
        description: "الوحدة الثالثة - الجبر",
        className: "الصف العاشر - علمي",
        subject: "الرياضيات",
        status: "مخطط",
      ),
      TeacherCalendarEvent(
        title: "اجتماع المدرسين",
        date: "١٥ نوفمبر",
        time: "١٠:٠٠ - ١١:٠٠",
        type: "اجتماع",
        color: Color(0xFF10B981),
        location: "قاعة الاجتماعات",
        description: "مناقشة الخطط الدراسية",
        className: "جميع الصفوف",
        subject: "اجتماع",
        status: "مخطط",
      ),
      TeacherCalendarEvent(
        title: "تصحيح أوراق الامتحان",
        date: "١٥ نوفمبر",
        time: "١:٠٠ - ٣:٠٠",
        type: "تصحيح",
        color: Color(0xFFDC2626),
        location: "غرفة المدرسين",
        description: "تصحيح امتحان منتصف الفصل",
        className: "الصف العاشر - علمي",
        subject: "الرياضيات",
        status: "متأخر",
      ),
      TeacherCalendarEvent(
        title: "تحضير درس العلوم",
        date: "١٥ نوفمبر",
        time: "٤:٠٠ - ٥:٠٠",
        type: "تحضير",
        color: Color(0xFF7C3AED),
        location: "المنزل",
        description: "تحضير تجربة التفاعلات الكيميائية",
        className: "الصف التاسع - أدبي",
        subject: "العلوم",
        status: "مكتمل",
      ),
    ];

    return allEvents.where((event) => event.date.contains('${day.day}')).toList();
  }

  List<TeacherCalendarEvent> _getEventsForMonth(DateTime month) {
    return _getEventsForDay(month);
  }

  List<TeacherCalendarEvent> _getEventsForTime(DateTime day, String time) {
    return _getEventsForDay(day).where((event) => event.time.contains(time)).toList();
  }

  List<TeacherCalendarEvent> _getWeeklyTasks() {
    return _getEventsForDay(
      _selectedDate,
    ).where((event) => event.type == "تصحيح" || event.type == "تحضير").toList();
  }

  List<TeacherCalendarEvent> _getDailyClasses() {
    return _getEventsForDay(_selectedDate).where((event) => event.type == "حصّة").toList();
  }

  List<TeacherCalendarEvent> _getDailyTasks() {
    return _getEventsForDay(
      _selectedDate,
    ).where((event) => event.type == "تصحيح" || event.type == "تحضير").toList();
  }

  List<TeacherCalendarEvent> _getUpcomingTasks() {
    return _getEventsForDay(_selectedDate);
  }
}

class TeacherCalendarEvent {
  final String title;
  final String date;
  final String time;
  final String type;
  final Color color;
  final String location;
  final String description;
  final String className;
  final String subject;
  final String status;

  TeacherCalendarEvent({
    required this.title,
    required this.date,
    required this.time,
    required this.type,
    required this.color,
    required this.location,
    required this.description,
    required this.className,
    required this.subject,
    required this.status,
  });
}
