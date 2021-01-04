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
using System.Net.Mail;
using System.Net;

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
            
            if (lang=="en" ) h.sermons = getPlayList(1,lang); //playlist of biblical feasts for english page only
            //set the current chosen language
            System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(lang);

            return View(h);
        }

        [HttpGet]
        public IActionResult Video(int sermonId, string lang)
        {
            if (lang == null) lang = "en";
            HomeModel h = new HomeModel();
            h.action = "Video";
            h.lang = lang;

            h.sermonId = sermonId;
            //get the sermon in the correct language if available
            h.videoId = getVideoIdOfLanguage(sermonId,lang);
            h.files = getSermonFiles(sermonId,lang);

            //h.sermons = getAllSermonsInGroupsOfaSermon(sermonId, lang);
            System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(lang);

            return View(h);
        }

        [HttpGet]
        public IActionResult About(string lang)
        {
            if (lang == null) lang = "en";
            HomeModel h = new HomeModel();
            h.action = "About";
            h.lang = lang;

            System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(lang);

            return View(h);
        }

        [HttpGet]
        public IActionResult Contact(string lang)
        {
            if (lang == null) lang = "en";
            ContactFormModel h = new ContactFormModel();
            h.action = "Contact";
            h.lang = lang;

            System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(lang);

            return View(h);
        }

        [HttpGet]
        public IActionResult Donate(string lang)
        {
            if (lang == null) lang = "en";
            HomeModel h = new HomeModel();
            h.action = "Donate";
            h.lang = lang;

            System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(lang);

            return View(h);
        }

        [HttpPost]
        public IActionResult Contact(ContactFormModel frm)
        {
            using (var message = new MailMessage(frm.email, "xxx@gmail.com"))
            {
                message.To.Add(new MailAddress("xxx@gmail.com"));
                message.From = new MailAddress(frm.email);
                message.Subject = frm.subject;
                message.Body = frm.message;
                
                System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;

                using (var smtpClient = new SmtpClient("smtp.gmail.com", 587))
                {
                    smtpClient.EnableSsl = true;
                    smtpClient.Credentials = new System.Net.NetworkCredential("xxx@gmail.com", "password");
                    smtpClient.Send(message);
                }
            }
            return RedirectToAction("Index", new { lang = frm.lang });
        }

        [HttpGet]
        public IActionResult Sermons(string lang)
        {
            if (lang == null) lang = "en";
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
            if (lang == null) lang = "en";
            HomeModel h = new HomeModel();
            h.action = "Articles";

            h.sermons = getArticles(lang);
            System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(lang);

            return View(h);
        }

        [HttpGet]
        public IActionResult Article(int sermonId, string lang)
        {
            HomeModel h = new HomeModel();
            h.action = "Article";
            h.sermonId = sermonId;

            //get article title, Speakername and reading_html from the datatabase
            string connectionString = _config.GetConnectionString("DefaultConnection");
            string cmdString = "exec getArticle @sermonId,@language";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(cmdString, connection);
                //command.Parameters.AddWithValue("lang", lang);
                command.Parameters.Add("@sermonId", SqlDbType.Int).Value = sermonId;
                command.Parameters.Add("@language", SqlDbType.NVarChar,2).Value = lang;

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        h.sermonTitle = reader["Title"].ToString();
                        h.speakerName = reader["SpeakerName"].ToString();
                        h.reading_html = reader["reading_html"].ToString();
                    }
                }
                connection.Close();
            }
            System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo(lang);
            System.Threading.Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo(lang);

            return View(h);
        }

        [HttpGet]
        public List<SermonModel> getArticles(string lang)
        {
            if (lang == null) lang = "en";
            string connectionString = _config.GetConnectionString("DefaultConnection");
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
                        s.opening = reader["Opening"].ToString();

                        lst.Add(s);
                    }
                }
                connection.Close();
            }

            return lst;
        }

        [HttpGet]
        public List<FileModel> getSermonFiles(int sermonId, string lang)
        {
            if (lang == null) lang = "en";
            string connectionString = _config.GetConnectionString("DefaultConnection");
            string cmdString = "exec getSermonFiles @sermonId, @lang";

            List<FileModel> lst = new List<FileModel>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(cmdString, connection);
                //command.Parameters.AddWithValue("lang", lang);
                command.Parameters.Add("@sermonId", SqlDbType.Int).Value = sermonId;
                command.Parameters.Add("@lang", SqlDbType.NVarChar, 2).Value = lang;

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        FileModel s = new FileModel();
                        //Console.WriteLine(String.Format("{0}, {1}", reader[0], reader[1]));
                        s.title = reader["title"].ToString();
                        s.mp3File = reader["mp3File"].ToString();

                        lst.Add(s);
                    }
                }
                connection.Close();
            }
            return lst;
        }

        [HttpGet]
        public List<SermonModel> getPlayList(int playListID, string lang)
        {
            string connectionString = _config.GetConnectionString("DefaultConnection");
            string cmdString = "exec getPlayList @playListID, @lang";

            List<SermonModel> lst = new List<SermonModel>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                SqlCommand command = new SqlCommand(cmdString, connection);
                //command.Parameters.AddWithValue("lang", lang);
                command.Parameters.Add("@playListID", SqlDbType.Int).Value = playListID;
                command.Parameters.Add("@lang", SqlDbType.NVarChar, 2).Value = lang;

                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        SermonModel s = new SermonModel();
                        //Console.WriteLine(String.Format("{0}, {1}", reader[0], reader[1]));
                        s.playListName = reader["playListName"].ToString();
                        s.title = reader["sermonTitle"].ToString();
                        s.sermonId = Convert.ToInt32(reader["sermonId"]);
                        s.language = reader["language"].ToString();
                        //s.videoId = reader["VideoId"].ToString();
                        //s.groups = reader["groups"].ToString();
                        //s.sermonDate = Convert.ToDateTime(reader["sermonDate"] is DBNull ? null : reader["sermonDate"]);
                        //s.speakerName = reader["speakerName"].ToString();
                        s.img = reader["img"].ToString();
                        s.row_num = Convert.ToInt32(reader["idx"]);
                        //s.opening = reader["Opening"].ToString();

                        lst.Add(s);
                    }
                }
                connection.Close();
            }

            return lst;
        }


        public string getVideoIdOfLanguage(int sermonId, string lang)
        {
            string connectionString = _config.GetConnectionString("DefaultConnection");
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
            string connectionString = _config.GetConnectionString("DefaultConnection");
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
            string connectionString = _config.GetConnectionString("DefaultConnection");
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
            string connectionString = _config.GetConnectionString("DefaultConnection");
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
