using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PenielSite2.Models
{
    public class SermonModel
    {
        public int sermonId { get; set; } 
        public string title { get; set; }
        public string language { get; set; }
        public string videoId { get; set; }
        public string groups { get; set; }
        public DateTime? sermonDate { get; set; }
        public string speakerName { get; set; }
        public int idx { get; set; }
        public string img { get; set; } //path to image of Article
        public int row_num { get; set; }
        public string opening { get; set; } //Predigt Vorspann
        public string playListName { get; set; }
    }
}
