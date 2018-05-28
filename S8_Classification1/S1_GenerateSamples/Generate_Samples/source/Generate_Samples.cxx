/*
  Author:Xiaoxia Qu
  Date:Mar.21th.2013
*/
#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"

#include "itkVector.h"
#include "itkListSample.h"
#include "itkImageRegionIterator.h"
#include "itkImageRegionConstIterator.h"

#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
using namespace std;
#include "itkLabelStatisticsImageFilter.h"
#include "itkCovarianceSampleFilter.h"


int main( int argc, char * argv [])
{

    if( argc < 17 )
    {
        std::cerr << "Missing command line arguments" << std::endl;

        std::cerr << "Usage : " << argv[0] << std::endl;

        std::cerr << "[1]Data with Labels, include CSF,CSF/GM,GM,GM/WM,WM,FCD" << std::endl;
        std::cerr << "[2]out.csv" << std::endl;
        std::cerr << "[3]Label Value " << std::endl;
        std::cerr << "[4]Frequency " << std::endl;

        std::cerr << " [5]GMthick"<< std::endl;
        std::cerr << " [6]GMthick_zscore"<< std::endl;
        std::cerr << " [7]Gradient" << std::endl;
        std::cerr << " [8]Gradient_zscore" << std::endl;
        std::cerr << " [9]GWBthick_Extend" << std::endl;
        std::cerr << " [10]GWBthick_Extend_zscore" << std::endl;
        std::cerr << " [11]RIM_smooth" << std::endl;
        std::cerr << " [12]RIM_smooth_zscore" << std::endl;
        std::cerr << " [13]sulcal_depth" << std::endl;
        std::cerr << " [14]sulcal_depth_zscore" << std::endl;
        std::cerr << " [15]curvatres" << std::endl;
        std::cerr << " [16]curvatres_zscore" << std::endl;

        return -1;
    }

    const unsigned int Dimension = 3;
    typedef float PixelType;
    typedef itk::Image<PixelType, Dimension > ImageType;
    typedef itk::ImageFileReader< ImageType > ReaderType;

    typedef unsigned char  LabelPixelType;
    typedef itk::Image<LabelPixelType, Dimension > LabelImageType;
    typedef itk::ImageFileReader< LabelImageType > LabelReaderType;
    LabelReaderType::Pointer reader1 = LabelReaderType::New();
    reader1->SetFileName( argv[1] );

    LabelPixelType Label = atof( argv[3] );
    unsigned int Frequency = atof( argv[4] );


    ReaderType::Pointer reader5 = ReaderType::New();
    reader5->SetFileName( argv[5] );
    ReaderType::Pointer reader6 = ReaderType::New();
    reader6->SetFileName( argv[6] );
    ReaderType::Pointer reader7 = ReaderType::New();
    reader7->SetFileName( argv[7] );
    ReaderType::Pointer reader8 = ReaderType::New();
    reader8->SetFileName( argv[8] );
    ReaderType::Pointer reader9 = ReaderType::New();
    reader9->SetFileName( argv[9] );
    ReaderType::Pointer reader10 = ReaderType::New();
    reader10->SetFileName( argv[10] );
    ReaderType::Pointer reader11 = ReaderType::New();
    reader11->SetFileName( argv[11] );
    ReaderType::Pointer reader12 = ReaderType::New();
    reader12->SetFileName( argv[12] );
    ReaderType::Pointer reader13 = ReaderType::New();
    reader13->SetFileName( argv[13] );
    ReaderType::Pointer reader14 = ReaderType::New();
    reader14->SetFileName( argv[14] );
    ReaderType::Pointer reader15 = ReaderType::New();
    reader15->SetFileName( argv[15] );
    ReaderType::Pointer reader16 = ReaderType::New();
    reader16->SetFileName( argv[16] );



    try
    {
        reader5->Update();
        reader6->Update();
        reader7->Update();
        reader8->Update();
        reader9->Update();
        reader10->Update();
        reader11->Update();
        reader12->Update();
        reader13->Update();
        reader14->Update();
        reader15->Update();
        reader16->Update();

        reader1->Update();
    }
    catch( itk::ExceptionObject & excp )
    {
        std::cerr << "Problem encoutered while reading image file"<< std::endl;
        std::cerr << excp << std::endl;
        return -1;
    }
    //*******************************************************************
    /* Generate Sample List for estimate parameters */
    //*******************************************************************
    const ImageType::RegionType   region= reader5->GetOutput()->GetBufferedRegion();
    typedef itk::ImageRegionConstIterator< ImageType > ConstIteratorType;

    ConstIteratorType it5 (reader5->GetOutput(), region);
    ConstIteratorType it6 (reader6->GetOutput(), region);
    ConstIteratorType it7 (reader7->GetOutput(), region);
    ConstIteratorType it8 (reader8->GetOutput(), region);
    ConstIteratorType it9 (reader9->GetOutput(), region);
    ConstIteratorType it10 (reader10->GetOutput(), region);
    ConstIteratorType it11 (reader11->GetOutput(), region);
    ConstIteratorType it12 (reader12->GetOutput(), region);
    ConstIteratorType it13 (reader13->GetOutput(), region);
    ConstIteratorType it14 (reader14->GetOutput(), region);
    ConstIteratorType it15 (reader15->GetOutput(), region);
    ConstIteratorType it16 (reader16->GetOutput(), region);

    typedef itk::ImageRegionConstIterator< LabelImageType > LabelConstIteratorType;
    LabelConstIteratorType it1 (reader1->GetOutput(), region);

    it5.GoToBegin();
    it6.GoToBegin();
    it7.GoToBegin();
    it8.GoToBegin();
    it9.GoToBegin();
    it10.GoToBegin();
    it11.GoToBegin();
    it12.GoToBegin();
    it13.GoToBegin();
    it14.GoToBegin();
    it15.GoToBegin();
    it16.GoToBegin();


    it1.GoToBegin();
    ofstream    outfile; //output files
    outfile.open(argv[2]);

    outfile<<"'GMthick,GMthickZscore,Gradient,GradientZscore,GWBthickExtend"<<","
              <<"GWBthickExtendZscore,RIMSmooth,RIMSmoothZscore"<<","
              <<"SulcalDepth,SulcalDepthZscore,Curvatres,CurvatresZscore,Label"<<std::endl;

    unsigned int i=0;
    PixelType SUM5=0;
    PixelType SUM6=0;
    PixelType SUM7=0;
    PixelType SUM8=0;
    PixelType SUM9=0;
    PixelType SUM10=0;
    PixelType SUM11=0;
    PixelType SUM12=0;
    PixelType SUM13=0;
    PixelType SUM14=0;
    PixelType SUM15=0;
    PixelType SUM16=0;

    while( !it1.IsAtEnd() )
    {
        if ((it1.Get()==Label)& (it5.Get()>0))
        {
            i=i+1;

               SUM5=SUM5+it5.Get();
               SUM6=SUM6+it6.Get();
               SUM7=SUM7+it7.Get();
               SUM8=SUM8+it8.Get();
               SUM9=SUM9+it9.Get();
               SUM10=SUM10+it10.Get();
               SUM11=SUM11+it11.Get();
               SUM12=SUM12+it12.Get();
               SUM13=SUM13+it13.Get();
               SUM14=SUM14+it14.Get();
               SUM15=SUM15+it15.Get();
               SUM16=SUM16+it16.Get();

            if (i==Frequency)
            {

                PixelType OutValue5=SUM5/Frequency;
                PixelType OutValue6=SUM6/Frequency;
                PixelType OutValue7=SUM7/Frequency;
                PixelType OutValue8=SUM8/Frequency;
                PixelType OutValue9=SUM9/Frequency;
                PixelType OutValue10=SUM10/Frequency;
                PixelType OutValue11=SUM11/Frequency;
                PixelType OutValue12=SUM12/Frequency;
                PixelType OutValue13=SUM13/Frequency;
                PixelType OutValue14=SUM14/Frequency;
                PixelType OutValue15=SUM15/Frequency;
                PixelType OutValue16=SUM16/Frequency;


                outfile<<OutValue5<<","<<OutValue6<<","<<OutValue7<<","<<OutValue8<<","
                       <<OutValue9<<","<<OutValue10<<","<<OutValue11<<","<<OutValue12<<","
                         <<OutValue13<<","<<OutValue14<<","<<OutValue15<<","<<OutValue16<<","
                     <<static_cast<itk::NumericTraits<LabelPixelType>::PrintType>(Label)
                    <<std::endl;

                i=0;
                SUM5=0;
                SUM6=0;
                SUM7=0;
                SUM8=0;
                SUM9=0;
                SUM10=0;
                SUM11=0;
                SUM12=0;
                SUM13=0;
                SUM14=0;
                SUM15=0;
                SUM16=0;
            }

        }
        ++it1;

        ++it5;
        ++it6;
        ++it7;
        ++it8;
        ++it9;
        ++it10;
        ++it11;
        ++it12;
        ++it13;
        ++it14;
        ++it15;
        ++it16;
    }

    outfile.close();

    return 0;
}
