# DIFFcmp.ctl: Compares the Collected Data
# $Id: DIFFcmp.ctl,v 1.5 2015/02/20 15:44:40 RDA Exp $
# ARCS: $Header: /home/cvs/cvs/RDA_8/src/scripting/lib/collect/TOOL/DIFFcmp.ctl,v 1.5 2015/02/20 15:44:40 RDA Exp $
#
# Change History
# 20150220  KRA  Improve list management.

=head1 NAME

TOOL:DIFFcmp - Compares the Collected Data

=head1 DESCRIPTION

This module compares the data collected about the operating system, the
database, and other data sources.

=cut

# -----------------------------------------------------------------------------
# Chapter macros
# -----------------------------------------------------------------------------

# Skip the beginning of the next chapter
macro find_chapter
{var (\%buf) = @arg

 while getLine($buf{'buf'})
 {var $lin = chomp(last)
  next !match($lin,'^(\-\-\-\+{1,}(!!)?)\s*(\w+)\:(\d+)\:(.*)')
  var ($buf{'toc'},undef,$buf{'cmd'},$buf{'num'},$buf{'ttl'}) = last
  debug '    Found ',$buf{'cmd'},' ',$buf{'num'},' in ',$buf{'buf'}
  if compare('eq',$buf{'cmd'},'CHAPTER')
   return 0
 }
 debug '    Found EOF in ',$buf{'buf'}
 var $buf{'eof'} = 1
 return 1
}

# Compare a chapter
macro compare_chapter
{var (\%buf1,\%buf2) = @arg

 debug " Inside TLdiff, compare CHAPTER '",$buf1{'num'},"/",$buf1{'ttl'},"'"
 write $buf1{'toc'},' ',$buf1{'ttl'}

 # Find the next tag in both files
 if find_tag(\%buf1)
  return 1
 if find_tag(\%buf2)
  return 1

 # When found, compare it
 while true
 {# Stop if a new chapter is found
  if compare('eq',$buf1{'cmd'},'CHAPTER')
  {if compare('eq',$buf2{'cmd'},'CHAPTER')
    return 0
   return skip_chapter(\%buf2)
  }
  if compare('eq',$buf2{'cmd'},'CHAPTER')
   return skip_chapter(\%buf1)

  # Treat a section or an introduction
  if expr('<',$buf1{'num'},$buf2{'num'})
  {if skip_block(\%buf1)
    return last
  }
  elsif expr('>',$buf1{'num'},$buf2{'num'})
  {if skip_block(\%buf2)
    return last
  }
  elsif compare_block(\%buf1,\%buf2)
   return last
 }
}

# Skip a chapter
macro skip_chapter
{var (\%buf) = @arg

 debug " Inside TLdiff, skip end of CHAPTER '",$buf{'num'},"/",$buf{'ttl'},\
       "' in ",$buf{'buf'}

 # Detect if whole chapter must be skipped
 if compare('eq',$buf{'cmd'},'CHAPTER')
 {write $buf{'toc'},' ',$buf{'ttl'}
  if find_tag(\%buf)
   return 1
 }

 # Skip sections
 while match($buf{'cmd'},'(INTRO|SECTION)')
 {if skip_block(\%buf)
   return last
 }
 return 0
}

# -----------------------------------------------------------------------------
# Introduction macros
# -----------------------------------------------------------------------------

# Generate the introduction table
macro gen_intro
{var (\@key,\%val1,\%val2,$ttl,$hdr) = @arg
 import $TOP
 keep $TOP

 prefix
 {write
  if $ttl
   write $ttl,':'
  write '|',field('\|',0,$hdr),'|*File 1*|*File 2*|'
 }
 loop $key (@key)
  write '|',$key,'|',nvl($val1{$key},'%R:Missing%'),'|',\
                     nvl($val2{$key},'%R:Missing%'),'|'
 if hasOutput(true)
  write $TOP
}

# Load introduction values
macro load_intro
{var (\%buf,\@key,\%val,\%ref) = @arg

 while getLine($buf{'buf'})
 {var $lin = chomp(last)
  if match($lin,'^\|(\*.*\*\s*)\|$')
   var ($buf{'hdr'}) = last
  elsif match($lin,'^\|(.*?)\|$')
  {var ($key,$val) = split('\|',last)
   var $key = trim($key)
   if !exists($ref{$key})
    call push(@key,$key)
   var $val{$key} = $val
  }
  else
   break
 }
}

# Merge an introduction
macro merge_intro
{var (\%buf1,\%buf2) = @arg

 debug " Inside TLdiff, merge INTRO '",$buf1{'num'},"/",$buf1{'ttl'},"'"

 # Load contributions
 var (@key,%val1,%val2) = ()
 call load_intro(\%buf1,\@key,\%val1,\%val1)
 call load_intro(\%buf2,\@key,\%val2,\%val1)

 # Generate the introduction table
 call gen_intro(\@key,\%val1,\%val2,$buf1{'ttl'},\
                nvl($buf1{'hdr'},$buf2{'hdr'},'*Parameter*'))
}

# Skip an introduction
macro skip_intro
{var (\%buf) = @arg

 debug " Inside TLdiff, skip INTRO '",$buf{'num'},"/",$buf{'ttl'},"'"

 # Load contributions
 var (@key,%val1,%val2) = ()
 if $buf{'flg'}
  call load_intro(\%buf,\@key,\%val1,\%val1)
 else
  call load_intro(\%buf,\@key,\%val2,\%val1)

 # Generate the introduction table
 call gen_intro(\@key,\%val1,\%val2,$buf{'ttl'},\
                nvl($buf{'hdr'},'*Parameter*'))
}

# -----------------------------------------------------------------------------
# Section macros
# -----------------------------------------------------------------------------

# Compare a section
macro compare_section
{var (\%buf1,\%buf2) = @arg

 debug " Inside TLdiff, compare SECTION '",$buf1{'num'},"/",$buf1{'ttl'},"'"

 if and(get_format(\%buf1),get_format(\%buf2))
 {var (@key,%val1,%val2)

  # Load the values
  call load_values(\%buf1,\@key,\%val1,\%val1)
  call load_values(\%buf2,\@key,\%val2,\%val1)

  # Compare the values
  var @fmt = split('\|', $buf1{'fmt'})
  if expr('>',scalar(@fmt),2)
   call cmp_alt_display(\%buf1,\@key,\%val1,\%val2,\@fmt)
  elsif match($fmt[1],'%BR%')
   call cmp_multi_value(\%buf1,\@key,\%val1,\%val2,\@fmt)
  elsif $fmt[1]
   call cmp_single_value(\%buf1,\@key,\%val1,\%val2,\@fmt)
 }
}

# Compare - Only the extra columns are displayed
macro cmp_alt_display
{var (\%buf,\@key,\%val1,\%val2,\@fmt) = @arg
 import $TOP
 keep $TOP

 var (undef,undef,@alt) = @fmt
 var $dft = @alt
 decr $dft,1
 var $dft = concat('%R:Missing%',repeat('|',$dft))
 var $fmt = join('|',@alt)

 prefix
 {write $buf{'toc'},' ',$buf{'ttl'}
  write '|',$fmt[0],'|',replace($fmt,'#',1,true),'|',\
                        replace($fmt,'#',2,true),'|'
 }
 loop $key (@key)
 {next compare('eq',$val1{$key},$val2{$key})
  if exists($val1{$key})
   var ($cmp1,$val1) = split('\|',$val1{$key},2)
  else
   var ($cmp1,$val1) = (undef,$dft)
  if exists($val2{$key})
   var ($cmp2,$val2) = split('\|',$val2{$key},2)
  else
   var ($cmp2,$val2) = (undef,$dft)
  if !compare('eq',$cmp1,$cmp2)
   write '|',$key,'|',$val1,'|',$val2,'|'
 }
 if hasOutput(true)
  write $TOP
}

# Compare - Second column can contain multiple information
macro cmp_multi_value
{var (\%buf,\@key,\%val1,\%val2,\@fmt) = @arg
 import $TOP
 keep $TOP

 var $fmt = $fmt[1]
 var @rec = split('%BR%',$fmt)
 var $num = @rec
 decr $num,1
 var $dft = concat('%R:Missing%',repeat('|',$num))
 var $fmt = replace($fmt,'%BR%','|',true)

 prefix
 {write $buf{'toc'},' ',$buf{'ttl'}
  write '|',$fmt[0],'|',replace($fmt,'#',1,true),'|',\
                        replace($fmt,'#',2,true),'|'
 }
 loop $key (@key)
 {next compare('eq',$val1{$key},$val2{$key})
  if !defined($val1{$key})
   var ($val1,$val2) = ($dft,replace($val2{$key},'%BR%','|',true))
  elsif !defined($val2{$key})
   var ($val1,$val2) = (replace($val1{$key},'%BR%','|',true),$dft)
  else
  {var (@val1,@res1) = split('%BR%',$val1{$key})
   var (@val2,@res2) = split('%BR%',$val2{$key})
   for $off (0,$num)
   {if compare('eq',$val1[$off],$val2[$off])
     var ($res1[$off],$res2[$off]) = (' ',' ')
    else
     var ($res1[$off],$res2[$off]) = (nvl($val1[$off],' '),nvl($val2[$off],' '))
   }
   var $val1 = join('|',@res1)
   var $val2 = join('|',@res2)
  }
  write '|',$key,'|',$val1,'|',$val2,'|'
 }
 if hasOutput(true)
  write $TOP
}

# Compare - Second column contains a single value
macro cmp_single_value
{var (\%buf,\@key,\%val1,\%val2,\@fmt) = @arg
 import $TOP
 keep $TOP

 prefix
 {write $buf{'toc'},' ',$buf{'ttl'}
  write '|',$fmt[0],'|',replace($fmt[1],'#',1,true),'|',\
                        replace($fmt[1],'#',2,true),'|'
 }
 loop $key (@key)
 {next compare('eq',$val1{$key},$val2{$key})
  write '|',$key,'|',nvl($val1{$key},'%R:Missing%'),'|',\
                     nvl($val2{$key},'%R:Missing%'),'|'
 }
 if hasOutput(true)
  write $TOP
}

# Extract a format line
macro get_format
{var (\%buf) = @arg

 if getLine($buf{'buf'})
 {var $lin = chomp(last)
  if match($lin,'^\|(\*.*\*\s*)\|$')
  {var ($buf{'fmt'}) = last
   return 1
  }
 }
 debug "Missing format for '",$buf{'num'},"/",$buf{'ttl'},"' in ",$buf{'buf'}
 return 0
}

# Load section values
macro load_values
{var (\%buf,\@key,\%val,\%ref) = @arg

 while getLine($buf{'buf'})
 {var $lin = chomp(last)
  if match($lin,'^\|(.*?)\|$')
  {var ($key,$val) = split('\|',last,2)
   var $key = trim($key)
   if !exists($ref{$key})
    call push(@key,$key)
   var $val{$key} = $val
  }
  else
   break
 }
}

# Skip a section
macro skip_section
{var (\%buf) = @arg

 debug " Inside TLdiff, skip SECTION '",$buf{'num'},"/",$buf{'ttl'},"'"

 if get_format(\%buf)
 {var (@key,%val1,%val2)

  # Load the values
  if $buf{'flg'}
   call load_values(\%buf,\@key,\%val1,\%val1)
  else
   call load_values(\%buf,\@key,\%val2,\%val1)

  # Compare the values
  var @fmt = split('\|', $buf{'fmt'})
  if expr('>',scalar(@fmt),2)
   call cmp_alt_display(\%buf,\@key,\%val1,\%val2,\@fmt)
  elsif match($fmt[1],'%BR%')
   call cmp_multi_value(\%buf,\@key,\%val1,\%val2,\@fmt)
  elsif $fmt[1]
   call cmp_single_value(\%buf,\@key,\%val1,\%val2,\@fmt)
 }
}

# -----------------------------------------------------------------------------
# Common macros
# -----------------------------------------------------------------------------

# Get the new chapter, introduction, or section
macro find_tag
{var (\%buf) = @arg

 while getLine($buf{'buf'})
 {var $lin = chomp(last)
  next !match($lin,'^(\-\-\-\+{1,}(!!)?)\s*(\w+)\:(\d+)\:(.*)')
  var ($buf{'toc'},undef,$buf{'cmd'},$buf{'num'},$buf{'ttl'}) = last
  debug '    Found ',$buf{'cmd'},' ',$buf{'num'},' in ',$buf{'buf'}
  return 0
 }
 debug '    Found EOF in ',$buf{'buf'}
 var $buf{'eof'} = 1
 return 1
}

# Skip a section or an introduction
macro skip_block
{var (\%buf) = @arg

 debug " Inside TLdiff, skip block '",$buf{'num'},"/",$buf{'ttl'},\
       "' in ",$buf{'buf'}

 # Process it
 if compare('eq',$buf{'cmd'},'SECTION')
  call skip_section(\%buf)
 elsif compare('eq',$buf{'cmd'},'INTRO')
  call skip_intro(\%buf)

 # Get the next tag
 return find_tag(\%buf)
}

# Skip file
macro skip_file
{var (\%buf) = @arg

 debug ' Inside TLdiff, skip end of ',$buf{'buf'}

 while true
 {if skip_chapter(\%buf)
   return 1
 }
}

# Treat a block
macro compare_block
{var (\%buf1,\%buf2) = @arg

 # Process it
 if compare('eq',$buf1{'cmd'},'SECTION')
  call compare_section(\%buf1,\%buf2)
 elsif compare('eq',$buf1{'cmd'},'INTRO')
  call merge_intro(\%buf1,\%buf2)

 # Get the next tag
 var $ret
 incr $ret,find_tag(\%buf1)
 incr $ret,find_tag(\%buf2)
 return $ret
}

# -----------------------------------------------------------------------------
# Compare files
# -----------------------------------------------------------------------------

import $TOC,$TOP

output E,diff
write '---+!! System Comparison / Differences'
write $TOC
write 'Note:'
write '   * An empty chapter indicates that no differences have been found.'

# Initilization
var ($fil1,$fil2) = @arg
var %buf1 = ('buf','RPT1',\
             'fil',catFile(${OUT.S},$fil1),\
             'flg',true)
var %buf2 = ('buf','RPT2',\
             'fil',catFile(${OUT.S},$fil2),\
             'flg',false)
if !createBuffer($buf1{'buf'},'R',$buf1{'fil'})
 die 'Cannot access ',$buf1{'fil'}
if !createBuffer($buf2{'buf'},'R',$buf2{'fil'})
 die 'Cannot access ',$buf2{'fil'}

# Find the first chapter in both file
debug ' Inside TLdiff, compare files'
if find_chapter(\%buf1)
 die 'Invalid data file ',$buf1{'fil'}
if find_chapter(\%buf2)
 die 'Invalid data file ',$buf2{'fil'}
if !expr('==',$buf1{'num'},0)
 die 'Truncated data file ',$buf1{'fil'}
if !expr('==',$buf2{'num'},0)
 die 'Truncated data file ',$buf2{'fil'}

# Compare all chapters
while true
{call compare_chapter(\%buf1,\%buf2)
 if and($buf1{'eof'},$buf2{'eof'})
  break
 if $buf1{'eof'}
 {call skip_file(\%buf2)
  break
 }
 if $buf2{'eof'}
 {call skip_file(\%buf1)
  break
 }
 if expr('<',$buf1{'num'},$buf2{'num'})
  call skip_chapter(\%buf1)
 if expr('>',$buf1{'num'},$buf2{'num'})
  call skip_chapter(\%buf2)
}

# Render the output file
call renderFile()
echo "Comparison result: ",last

return

=head1 COMPARISON FILE FORMAT

  ---+ CHAPTER:<n>:title

  ---+ INTRO:<n>:title
  |*<heading>*|*<heading>*|
  |<parameter>|<value>|
  ...
  [[#Top][Back to Top]]

  ---+ SECTION:<n>:title
  |*<heading>*|*<heading>*|
  |<parameter>|<value>|
  ...
  [[#Top][Back to Top]]

Increasing numbers must be used for each chapter. The introduction and sections
must have increasing numbers in each chapter.

In each section, the parameter name is a unique identifier.

Alternative section formats are available.

  ---+ SECTION:<n>:title
  |*<heading>*|*<heading>*|*<heading1>*|...|
  |<parameter>|<value>|<value1>|...|
  ...
  [[#Top][Back to Top]]

For these sections, the second column is used for comparing records, and the
following columns for the final report.

  ---+ SECTION:<n>:title
  |*<heading>*|*<heading>*%BR%...|
  |<parameter>|<value>%BR%...|
  ...
  [[#Top][Back to Top]]

RDA uses this format to associate multiple information pieces to the same
parameter. The heading of the second column indicates how many different
elements are stored in the corresponding cells.

=head1 SEE ALSO

L<TOOL:DIFFget|collect::TOOL:DIFFget>,
L<TOOL:TLdiff|collect::TOOL:TLdiff>

=begin credits

=over 10

=item RDA 4.10:  Michel Villette.

=back

=head1 COPYRIGHT NOTICE

Copyright (c) 2002, 2016, Oracle and/or its affiliates. All rights reserved.

=head1 TRADEMARK NOTICE

Oracle and Java are registered trademarks of Oracle and/or its
affiliates. Other names may be trademarks of their respective owners.

=cut
