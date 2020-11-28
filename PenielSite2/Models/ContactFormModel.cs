using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace PenielSite2.Models
{
    public class ContactFormModel
    {
        public string action { get; set; }
        public int sermonId { get; set; }
        public string lang { get; set; }
        [Required]
        public string name { get; set; }
        [Required]
        public string email { get; set; }
        [Required]
        public string subject { get; set; }
        [Required]
        public string message { get; set; }

    }

}
