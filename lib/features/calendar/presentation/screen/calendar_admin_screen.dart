import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AdminCalendarScreen extends StatefulWidget {
  const AdminCalendarScreen({super.key});

  @override
  State<AdminCalendarScreen> createState() => _AdminCalendarScreenState();
}

class _AdminCalendarScreenState extends State<AdminCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  int _currentView = 0; // 0: شهري, 1: أسبوعي, 2: يومي
  String _selectedFilter = AppLocalKay.filter_all.tr(); // تصفية الأحداث
  List<String> _filters = [
    AppLocalKay.filter_all.tr(),
    AppLocalKay.school_events.tr(),
    AppLocalKay.school_activities.tr(),
    AppLocalKay.school_exams.tr(),
    AppLocalKay.school_holidays.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // رأس الصفحة
            _buildHeader(),
            // شريط التحكم والتصفية
            _buildControlBar(),
            // عرض التقويم
            Expanded(child: _buildCalendarContent()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEvent,
        backgroundColor: const Color(0xFF9C27B0),
        child: Icon(Icons.add_rounded, color: AppColor.whiteColor(context), size: 24.w),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
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
                AppLocalKay.school_calendar.tr(),
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
              color: const Color(0xFF9C27B0).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.calendar_month_rounded, color: const Color(0xFF9C27B0), size: 24.w),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColor.whiteColor(context),
      child: Column(
        children: [
          // تصفية الأحداث
          _buildFilterSelector(),
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
                      _buildViewButton(AppLocalKay.backupFrequencyDaily.tr(), 0),
                      _buildViewButton(AppLocalKay.backupFrequencyWeekly.tr(), 1),
                      _buildViewButton(AppLocalKay.backupFrequencyMonthly.tr(), 2),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withOpacity(0.1),
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
                      color: const Color(0xFF9C27B0).withOpacity(0.3),
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

  Widget _buildFilterSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters
            .map(
              (filter) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: FilterChip(
                  label: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _selectedFilter == filter
                          ? AppColor.whiteColor(context)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  selected: _selectedFilter == filter,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedFilter = selected ? filter : AppLocalKay.filter_all.tr();
                    });
                  },
                  backgroundColor: AppColor.whiteColor(context),
                  selectedColor: const Color(0xFF9C27B0),
                  checkmarkColor: AppColor.whiteColor(context),
                  side: BorderSide(
                    color: _selectedFilter == filter
                        ? const Color(0xFF9C27B0)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
              ),
            )
            .toList(),
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
            color: isSelected ? const Color(0xFF9C27B0) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColor.whiteColor(context) : const Color(0xFF6B7280),
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
                    color: const Color(0xFF9C27B0),
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

        List<AdminCalendarEvent> dayEvents = _getEventsForDay(
          DateTime(_selectedDate.year, _selectedDate.month, dayNumber),
        );

        return GestureDetector(
          onTap: () => setState(() {
            _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, dayNumber);
          }),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF9C27B0)
                  : isToday
                  ? const Color(0xFF9C27B0).withOpacity(0.1)
                  : AppColor.whiteColor(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isToday ? const Color(0xFF9C27B0) : Colors.transparent,
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
                    color: isSelected ? AppColor.whiteColor(context) : const Color(0xFF1F2937),
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
                                color: isSelected ? AppColor.whiteColor(context) : event.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      if (dayEvents.length > 2)
                        Text(
                          '+${dayEvents.length - 2}',
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: isSelected
                                ? AppColor.whiteColor(context)
                                : const Color(0xFF6B7280),
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
    List<AdminCalendarEvent> monthEvents = _getEventsForMonth(_selectedDate);

    Map<String, int> eventCounts = {};
    for (var event in monthEvents) {
      eventCounts[event.type] = (eventCounts[event.type] ?? 0) + 1;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
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
                AppLocalKay.school_statistics.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${monthEvents.length} حدث",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF9C27B0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                AppLocalKay.school_events.tr(),
                eventCounts["اجتماع"] ?? 0,
                Color(0xFFF59E0B),
                Icons.groups_rounded,
              ),
              _buildStatItem(
                AppLocalKay.school_activities.tr(),
                eventCounts["فعالية"] ?? 0,
                Color(0xFF10B981),
                Icons.celebration_rounded,
              ),
              _buildStatItem(
                AppLocalKay.school_exams.tr(),
                eventCounts["اختبار"] ?? 0,
                Color(0xFFDC2626),
                Icons.quiz_rounded,
              ),
              _buildStatItem(
                AppLocalKay.school_holidays.tr(),
                eventCounts["عطلة"] ?? 0,
                Color(0xFF7C3AED),
                Icons.beach_access_rounded,
              ),
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
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16.w, color: color),
        ),
        SizedBox(height: 6.h),
        Text(
          '$count',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 2.h),
        Text(
          title,
          style: TextStyle(fontSize: 10.sp, color: const Color(0xFF6B7280)),
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
          _buildSchoolSchedule(),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    DateTime startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));

    return Column(
      children: List.generate(7, (index) {
        DateTime day = startOfWeek.add(Duration(days: index));
        List<AdminCalendarEvent> dayEvents = _getEventsForDay(day);
        bool isToday = _isSameDay(day, DateTime.now());
        bool isSelected = _isSameDay(day, _selectedDate);

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = day),
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF9C27B0)
                    : isToday
                    ? const Color(0xFF9C27B0).withOpacity(0.3)
                    : Colors.transparent,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blackColor(context).withOpacity(0.05),
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
                      color: const Color(0xFF9C27B0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '+${dayEvents.length - 2}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFF9C27B0),
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

  Widget _buildSchoolSchedule() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
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
                AppLocalKay.school_timetable.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "الأسبوع ${_getWeekNumber(_selectedDate)}",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF9C27B0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Column(children: _getWeeklyEvents().map((event) => _buildScheduleItem(event)).toList()),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(AdminCalendarEvent event) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: event.color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(color: event.color, borderRadius: BorderRadius.circular(2)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 12.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      "${event.date} • ${event.time}",
                      style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.location_on_rounded, size: 12.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      event.location,
                      style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                    ),
                  ],
                ),
                if (event.description.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    event.description,
                    style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
              style: TextStyle(fontSize: 10.sp, color: event.color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyView() {
    List<AdminCalendarEvent> dailyEvents = _getEventsForDay(_selectedDate);

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
          // ملخص اليوم
          _buildDailySummary(),
        ],
      ),
    );
  }

  Widget _buildDailyHeader(int eventCount) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
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
              color: const Color(0xFF9C27B0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.today_rounded, color: const Color(0xFF9C27B0), size: 20.w),
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
                  color: const Color(0xFF9C27B0),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                AppLocalKay.today_schedule.tr(),
                style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(AdminCalendarEvent event) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4.w,
                height: 60.h,
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
                        SizedBox(width: 8.w),
                        if (event.priority == "عالي")
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              AppLocalKay.important.tr(),
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: const Color(0xFFDC2626),
                                fontWeight: FontWeight.w600,
                              ),
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
                    if (event.participants.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Text(
                        "${AppLocalKay.participants.tr()} ${event.participants.join('، ')}",
                        style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // إجراءات سريعة
          _buildEventActions(event),
        ],
      ),
    );
  }

  Widget _buildEventActions(AdminCalendarEvent event) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.edit_rounded, size: 16.w),
            label: Text(AppLocalKay.user_management_edit.tr()),
            onPressed: () => _editEvent(event),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF9C27B0),
              side: BorderSide(color: const Color(0xFF9C27B0).withOpacity(0.3)),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.notifications_none_rounded, size: 16.w),
            label: Text(AppLocalKay.reminder.tr(), style: AppTextStyle.bodyMedium(context)),
            onPressed: () => _setReminder(event),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2196F3),
              side: BorderSide(color: const Color(0xFF2196F3).withOpacity(0.3)),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.share_rounded, size: 16.w),
            label: Text(AppLocalKay.share.tr(), style: AppTextStyle.bodyMedium(context)),
            onPressed: () => _shareEvent(event),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF10B981),
              side: BorderSide(color: const Color(0xFF10B981).withOpacity(0.3)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailySummary() {
    List<AdminCalendarEvent> dailyEvents = _getEventsForDay(_selectedDate);

    Map<String, int> eventCounts = {};
    for (var event in dailyEvents) {
      eventCounts[event.type] = (eventCounts[event.type] ?? 0) + 1;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalKay.summary_today.tr(),
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
              _buildDailySummaryItem(
                AppLocalKay.total_events.tr(),
                dailyEvents.length,
                Icons.event_rounded,
                Color(0xFF9C27B0),
              ),
              _buildDailySummaryItem(
                AppLocalKay.school_events.tr(),
                eventCounts["اجتماع"] ?? 0,
                Icons.groups_rounded,
                Color(0xFFF59E0B),
              ),
              _buildDailySummaryItem(
                AppLocalKay.school_activities.tr(),
                eventCounts["فعالية"] ?? 0,
                Icons.celebration_rounded,
                Color(0xFF10B981),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailySummaryItem(String title, int count, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16.w, color: color),
        ),
        SizedBox(height: 6.h),
        Text(
          '$count',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 2.h),
        Text(
          title,
          style: TextStyle(fontSize: 10.sp, color: const Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents() {
    List<AdminCalendarEvent> upcomingEvents = _getUpcomingEvents();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalKay.upcoming_events.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                AppLocalKay.show_all.tr(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF9C27B0),
                  fontWeight: FontWeight.w600,
                ),
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

  Widget _buildUpcomingEventItem(AdminCalendarEvent event) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.03),
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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: event.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        event.type,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: event.color,
                          fontWeight: FontWeight.w600,
                        ),
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
          IconButton(
            icon: Icon(Icons.more_vert_rounded, size: 16.w),
            onPressed: () {},
            color: const Color(0xFF6B7280),
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
          Icon(Icons.calendar_today_rounded, size: 48.w, color: const Color(0xFF9CA3AF)),
          SizedBox(height: 12.h),
          Text(
            AppLocalKay.no_events.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            AppLocalKay.no_events_today.tr(),
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            icon: Icon(Icons.add_rounded, size: 16.w),
            label: Text(
              AppLocalKay.new_event.tr(),
              style: AppTextStyle.bodyMedium(context, color: AppColor.whiteColor(context)),
            ),
            onPressed: _addNewEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: AppColor.whiteColor(context),
            ),
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

  int _getWeekNumber(DateTime date) {
    int firstDay = DateTime(date.year, 1, 1).weekday;
    int days = date.difference(DateTime(date.year, 1, 1)).inDays;
    return ((days + firstDay - 1) / 7).floor() + 1;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // دوال الإجراءات
  void _addNewEvent() {}

  void _editEvent(AdminCalendarEvent event) {}

  void _setReminder(AdminCalendarEvent event) {}

  void _shareEvent(AdminCalendarEvent event) {}

  // بيانات تجريبية للأحداث
  List<AdminCalendarEvent> _getEventsForDay(DateTime day) {
    List<AdminCalendarEvent> allEvents = [
      AdminCalendarEvent(
        title: "اجتماع مجلس الإدارة",
        date: "١٥ نوفمبر",
        time: "٩:٠٠ ص - ١٠:٣٠ ص",
        type: "اجتماع",
        color: Color(0xFFF59E0B),
        location: "قاعة الاجتماعات الرئيسية",
        description: "مناقشة الميزانية والتخطيط للفصل الدراسي الثاني",
        participants: ["مدير المدرسة", "نائب المدير", "رؤساء الأقسام"],
        priority: "عالي",
      ),
      AdminCalendarEvent(
        title: "حفل تكريم المتفوقين",
        date: "١٥ نوفمبر",
        time: "١١:٠٠ ص - ١٢:٣٠ م",
        type: "فعالية",
        color: Color(0xFF10B981),
        location: "المسرح المدرسي",
        description: "تكريم الطلاب المتفوقين في الفصل الدراسي الأول",
        participants: ["جميع الطلاب", "أولياء الأمور", "الهيئة التعليمية"],
        priority: "متوسط",
      ),
      AdminCalendarEvent(
        title: "اختبارات منتصف الفصل",
        date: "١٨ نوفمبر",
        time: "كامل اليوم",
        type: "اختبار",
        color: Color(0xFFDC2626),
        location: "الفصول الدراسية",
        description: "اختبارات منتصف الفصل الدراسي الثاني لجميع الصفوف",
        participants: ["جميع الطلاب", "المعلمين"],
        priority: "عالي",
      ),
      AdminCalendarEvent(
        title: "عطلة العيد الوطني",
        date: "٢٠ نوفمبر",
        time: "كامل اليوم",
        type: "عطلة",
        color: Color(0xFF7C3AED),
        location: "-",
        description: "عطلة بمناسبة العيد الوطني",
        participants: ["جميع الطلاب", "الهيئة التعليمية"],
        priority: "منخفض",
      ),
      AdminCalendarEvent(
        title: "ورشة تطوير المعلمين",
        date: "٢٢ نوفمبر",
        time: "٢:٠٠ م - ٤:٠٠ م",
        type: "اجتماع",
        color: Color(0xFFF59E0B),
        location: "معمل الحاسوب",
        description: "ورشة عمل حول استراتيجيات التدريس الحديثة",
        participants: ["جميع المعلمين"],
        priority: "متوسط",
      ),
    ];

    return allEvents.where((event) => event.date.contains('${day.day}')).toList();
  }

  List<AdminCalendarEvent> _getEventsForMonth(DateTime month) {
    return _getEventsForDay(month);
  }

  List<AdminCalendarEvent> _getWeeklyEvents() {
    return _getEventsForDay(_selectedDate);
  }

  List<AdminCalendarEvent> _getUpcomingEvents() {
    return _getEventsForDay(_selectedDate);
  }
}

class AdminCalendarEvent {
  final String title;
  final String date;
  final String time;
  final String type;
  final Color color;
  final String location;
  final String description;
  final List<String> participants;
  final String priority;

  AdminCalendarEvent({
    required this.title,
    required this.date,
    required this.time,
    required this.type,
    required this.color,
    required this.location,
    required this.description,
    required this.participants,
    required this.priority,
  });
}
