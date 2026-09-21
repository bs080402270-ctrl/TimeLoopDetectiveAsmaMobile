using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;

namespace TimeLoopDetective
{
    // Small JSON reader used only to preserve string-keyed dictionaries from existing case files.
    public static class MiniJson
    {
        public static object Deserialize(string json) => Parser.Parse(json);
        sealed class Parser : IDisposable
        {
            readonly StringReader r; Parser(string json){r=new StringReader(json);}
            public static object Parse(string json){using var p=new Parser(json);return p.Value();}
            public void Dispose(){r.Dispose();}
            object Value(){Eat();int c=r.Peek();if(c=='{')return Obj();if(c=='[')return Arr();if(c=='"')return Str();if(c=='t'||c=='f')return Bool();if(c=='n'){for(int i=0;i<4;i++)r.Read();return null;}return Num();}
            Dictionary<string,object> Obj(){var d=new Dictionary<string,object>();r.Read();while(true){Eat();if(r.Peek()=='}'){r.Read();return d;}var k=Str();Eat();r.Read();d[k]=Value();Eat();int c=r.Read();if(c=='}')return d;}}
            List<object> Arr(){var a=new List<object>();r.Read();while(true){Eat();if(r.Peek()==']'){r.Read();return a;}a.Add(Value());Eat();int c=r.Read();if(c==']')return a;}}
            string Str(){var sb=new StringBuilder();r.Read();while(true){int c=r.Read();if(c<0||c=='"')break;if(c=='\\'){c=r.Read();if(c=='n')sb.Append('\n');else if(c=='r')sb.Append('\r');else if(c=='t')sb.Append('\t');else if(c=='b')sb.Append('\b');else if(c=='f')sb.Append('\f');else if(c=='u'){var h=new char[4];for(int i=0;i<4;i++)h[i]=(char)r.Read();sb.Append((char)Convert.ToInt32(new string(h),16));}else sb.Append((char)c);}else sb.Append((char)c);}return sb.ToString();}
            object Num(){var sb=new StringBuilder();while(r.Peek()>=0 && "-+0123456789.eE".IndexOf((char)r.Peek())>=0)sb.Append((char)r.Read());var s=sb.ToString();if(s.IndexOfAny(new[]{'.','e','E'})>=0)return double.Parse(s,CultureInfo.InvariantCulture);return long.Parse(s,CultureInfo.InvariantCulture);}
            bool Bool(){if(r.Peek()=='t'){for(int i=0;i<4;i++)r.Read();return true;}for(int i=0;i<5;i++)r.Read();return false;}
            void Eat(){while(char.IsWhiteSpace((char)r.Peek()))r.Read();}
        }
    }
}
