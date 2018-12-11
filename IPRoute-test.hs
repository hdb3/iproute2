module Main where
import IPRoute
import Control.Monad(mapM_)

main = do 
    numberedInterfaces <- getNumberedInterfaces
    print ("numberedInterfaces",numberedInterfaces)
    interfaces <- getAllInterfaces
    print ("interfaces",interfaces)
    physicalInterfaces <- getPhysicalInterfaces
    print ("physicalInterfaces",physicalInterfaces)
    unnumberedInterfaces <- getUnnumberedInterfaces
    print ("unnumberedInterfaces",unnumberedInterfaces)
    arpTable <- getARPTable_
    print ("arpTable",arpTable)

    putStrLn "\nunnumbered interface ARP table\n  ------"
    let unnumberedARP = map (\dev -> lookup dev arpTable) unnumberedInterfaces
    print unnumberedARP
    mapM_ processUnnumberedInterface unnumberedInterfaces

processUnnumberedInterface dev = do
    routes <- getDevARPTable dev
    putStrLn $ "processUnnumberedInterface: " ++ show dev ++ " - " ++ show routes
    mapM_ (addHostRoute dev) routes
