using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using PenielSite2.Models;
using Microsoft.Data.SqlClient;
using System.Data;
using Microsoft.Extensions.Localization;
using PenielSite2.Localize;
using System.Globalization;

namespace PenielSite2.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IConfiguration _config;
        private readonly IStringLocalizer<Resource> _loc;

        public HomeController(ILogger<HomeController> logger, IConfiguration config, IStringLocalizer<Resource> localizer)
        {
            _logger = logger;
            _config = config;
            _loc = localizer;
        }

        [HttpGet]
        public IActionResult Index(string lang)
        {
            if (lang == null) lang = "en";
            HomeModel h = new HomeModel();
            h.lang = lang;
            h.action = "Index";
            //set the current chosen language
            System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(lang);

            return View(h);
        }

        [HttpGet]
        public IActionResult Video(int sermonId, string lang)
        {
            HomeModel h = new HomeModel();
            h.action = "Video";

            h.sermonId = sermonId;
            //get the sermon in the correct language if available
            h.videoId = getVideoIdOfLanguage(sermonId,lang);

            h.sermons = getAllSermonsInGroupsOfaSermon(sermonId, lang);
            System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(lang);

            return View(h);
        }

        [HttpGet]
        public IActionResult Sermons(string lang)
        {
            HomeModel h = new HomeModel();
            h.action = "Sermons";
            h.lang = lang;

            System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(lang);

            return View(h);
        }

        [HttpGet]
        public IActionResult Articles(string lang)
        {
            HomeModel h = new HomeModel();
            h.action = "Articles";

            h.sermons = getArticles(lang);
            System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(lang);

            return View(h);
        }

        [HttpGet]
        public List<SermonModel> getArticles(string lang)
        {
            if (lang == null) lang = "en";
            string connectionString = _config.GetConnectionString("DefaultSQLConnection");
            string cmdString = "exec getSermons @lang,@groupId,@sermonType,@fromDate,@toDate";

            List<SermonModel> lst = new List<SermonModel>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(cmdString, connection);
                //command.Parameters.AddWithValue("lang", lang);
                command.Parameters.Add("@lang", SqlDbType.NVarChar, 2).Value = lang;
                command.Parameters.Add("@groupId", SqlDbType.Int).Value = 0;
                command.Parameters.Add("@sermonType", SqlDbType.NVarChar, 10).Value = "A"; //Articles
                command.Parameters.Add("@fromDate", SqlDbType.Date).Value = "1980/01/01";
                command.Parameters.Add("@toDate", SqlDbType.Date).Value = "2099/12/31";

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        SermonModel s = new SermonModel();
                        //Console.WriteLine(String.Format("{0}, {1}", reader[0], reader[1]));
                        s.sermonId = Convert.ToInt32(reader["sermonId"]);
                        s.title = reader["title"].ToString();
                        s.language = reader["language"].ToString();
                        //s.videoId = reader["videoId"].ToString();
                        s.groups = reader["groups"].ToString();
                        s.sermonDate = Convert.ToDateTime(reader["sermonDate"] is DBNull ? null : reader["sermonDate"]);
                        s.speakerName = reader["speakerName"].ToString();
                        s.img = reader["img"].ToString();
                        s.row_num = Convert.ToInt32(reader["row_num"]);

                        lst.Add(s);
                    }
                }
                connection.Close();
            }

            return lst;
        }

        public string getVideoIdOfLanguage(int sermonId, string lang)
        {
            string connectionString = _config.GetConnectionString("DefaultSQLConnection");
            string cmdString = "select dbo.getVideoIdOfLanguage(@sermonId, @lang)";
            string videoIdOfLanguage;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(cmdString, connection);
                command.Parameters.Add("@sermonId", SqlDbType.NVarChar, 11).Value = sermonId;
                command.Parameters.Add("@lang", SqlDbType.NVarChar, 2).Value = lang;

                connection.Open();
                videoIdOfLanguage = command.ExecuteScalar().ToString();
                connection.Close();
                return videoIdOfLanguage;
            }
        }
            //[HttpGet]
            public List<SermonModel> getAllSermonsInGroupsOfaSermon(int sermonId, string lang)
        {
            if (lang == null) lang = "en";
            string connectionString = _config.GetConnectionString("DefaultSQLConnection");
            string cmdString = "exec getAllSermonsInGroupsOfaSermon @sermonId, @lang, @sermonType";

            List<SermonModel> lst = new List<SermonModel>();
            int idx = 0;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(cmdString, connection);
                //command.Parameters.AddWithValue("lang", lang);
                command.Parameters.Add("@sermonId", SqlDbType.NVarChar, 11).Value = sermonId;
                command.Parameters.Add("@lang", SqlDbType.NVarChar, 2).Value = lang;
                command.Parameters.Add("@sermonType", SqlDbType.NVarChar, 10).Value = "All";

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        SermonModel s = new SermonModel();
                        //Console.WriteLine(String.Format("{0}, {1}", reader[0], reader[1]));
                        s.sermonId = Convert.ToInt32(reader["sermonId"]);
                        s.title = reader["title"].ToString();
                        s.language = reader["language"].ToString();
                        s.videoId = reader["videoId"].ToString();
                        s.groups = reader["groups"].ToString();
                        s.sermonDate = Convert.ToDateTime(reader["sermonDate"] is DBNull ? null : reader["sermonDate"]);
                        s.speakerName = reader["speakerName"].ToString();
                        s.idx = idx;

                        idx++;
                        lst.Add(s);
                    }
                }
                connection.Close();
            }

            return (lst);
        }

        [HttpGet]
        public IActionResult getLastMessages(string lang)
        {
            if (lang == null) lang = "en";
            string connectionString = _config.GetConnectionString("DefaultSQLConnection");
            string cmdString = "exec getLastMessages @lang";

            List<SermonModel> lst = new List<SermonModel>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(cmdString, connection);
                //command.Parameters.AddWithValue("lang", lang);
                command.Parameters.Add("@lang", SqlDbType.NVarChar, 2).Value = lang;

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        SermonModel s = new SermonModel();
                        //Console.WriteLine(String.Format("{0}, {1}", reader[0], reader[1]));
                        s.sermonId = Convert.ToInt32(reader["sermonId"]);
                        s.title = reader["title"].ToString();
                        s.language = reader["language"].ToString();
                        s.videoId = reader["videoId"].ToString();
                        s.groups = reader["groups"].ToString();
                        s.sermonDate = Convert.ToDateTime(reader["sermonDate"] is DBNull ? null : reader["sermonDate"]);
                        s.speakerName = reader["speakerName"].ToString();

                        lst.Add(s);
                    }
                }
                connection.Close();
            }

            var slst = (from l in lst
                       select new { 
                            sid = l.sermonId,
                            t = l.title, 
                            g = l.groups, 
                            sd = l.sermonDate, 
                            v = l.videoId,
                            sn = l.speakerName});

            return Json(slst);
        }

        [HttpGet]
        public IActionResult getSermons(string lang, int groupId, string sermonType, string fromDate, string toDate )
        {
            if (lang == null) lang = "en";
            string connectionString = _config.GetConnectionString("DefaultSQLConnection");
            string cmdString = "exec getSermons @lang,@groupId,@sermonType,@fromDate,@toDate";

            List<SermonModel> lst = new List<SermonModel>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(cmdString, connection);
                //command.Parameters.AddWithValue("lang", lang);
                command.Parameters.Add("@lang", SqlDbType.NVarChar, 2).Value = lang;
                command.Parameters.Add("@groupId", SqlDbType.Int).Value = groupId;
                command.Parameters.Add("@sermonType", SqlDbType.NVarChar, 10).Value = sermonType;
                command.Parameters.Add("@fromDate", SqlDbType.Date).Value = fromDate;
                command.Parameters.Add("@toDate", SqlDbType.Date).Value = toDate;

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        SermonModel s = new SermonModel();
                        //Console.WriteLine(String.Format("{0}, {1}", reader[0], reader[1]));
                        s.sermonId = Convert.ToInt32(reader["sermonId"]);
                        s.title = reader["title"].ToString();
                        s.language = reader["language"].ToString();
                        s.videoId = reader["videoId"].ToString();
                        s.groups = reader["groups"].ToString();
                        s.sermonDate = Convert.ToDateTime(reader["sermonDate"] is DBNull ? null : reader["sermonDate"]);
                        s.speakerName = reader["speakerName"].ToString();

                        lst.Add(s);
                    }
                }
                connection.Close();
            }

            var slst = (from l in lst
                        select new
                        {
                            sid = l.sermonId,
                            t = l.title,
                            g = l.groups,
                            sd = l.sermonDate,
                            v = l.videoId,
                            sn = l.speakerName
                        });

            return Json(slst);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
