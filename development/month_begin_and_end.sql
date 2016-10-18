

DECLARE @m INT = 1;
DECLARE @y INT = 2015;

DECLARE @date DATE = CAST(CAST(@y AS VARCHAR) + '-' + CAST(@m AS VARCHAR) + '-10' AS DATE);
PRINT '"Today" :' + CAST(@date AS VARCHAR)
--	2015-01-10

DECLARE @begin_prev_month DATE = DATEADD(m, DATEDIFF(m,0,@date)-1,0);
PRINT 'Beginning of previous month: ' + CAST(@begin_prev_month AS VARCHAR);
DECLARE @begin_this_month DATE = DATEADD(m, DATEDIFF(m,0,@date),0);
PRINT 'Beginning of this month: ' + CAST(@begin_this_month AS VARCHAR);

PRINT 'Months since sometime ago: ' + CAST(DATEDIFF(m,0,@date) AS VARCHAR);
--	1380
PRINT 'Beginning of next month: ' + CAST(DATEADD(m, DATEDIFF(m,0,@date)+1,0) AS VARCHAR);
--	Feb  1 2015 12:00AM

DECLARE @end_this_month DATE = DATEADD(s,-1,DATEADD(m, DATEDIFF(m,0,@date)+1,0));
PRINT 'End of next month :' + CAST(@end_this_month AS VARCHAR);
--	2015-01-31

DECLARE @end_next_month DATE = DATEADD(s,-1,DATEADD(m, DATEDIFF(m,0,@date)+2,0));
PRINT 'End of next month :' + CAST(@end_next_month AS VARCHAR);
--	2015-02-28



