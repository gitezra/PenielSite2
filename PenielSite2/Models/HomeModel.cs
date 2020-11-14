using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PenielSite2.Models
{
    public class HomeModel
    {
        public string lang { get; set; }
        public int sermonId { get; set; }
        public string videoId { get; set; }
        public List<SermonModel> sermons { get; set; }
        public string action { get; set; }
        public string reading_html { get; set; }
        public string speakerName { get; set; }
        public string sermonTitle { get; set; }
    }
}
