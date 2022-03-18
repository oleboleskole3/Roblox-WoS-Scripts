const fs = require('fs')
const path = require('path')

let errors = 0, libsImported = 0, filesDone = 0

fs.readdirSync('src').forEach(filePath => {
    if (fs.existsSync(path.join('bin', filePath))) fs.unlinkSync(path.join('bin', filePath))
    fs.readFileSync(path.join('src', filePath), 'utf-8').split('\n').forEach(line => {
        line = line.trim()
        const matches = /(?<=(#include ))(.{1,})$/.exec(line)
        if (matches) {
            const libPath = matches[0]
            if (!fs.existsSync(path.join('libs', libPath))) {
                console.error(`Library "${libPath}" does not exist in the libs directory`)               
                fs.appendFileSync(path.join('bin', filePath), line.replace(`#include ${libPath}`, `Library "${libPath}" not found\n`))
                errors++
                return
            }

            console.log('Importing library', libPath, 'into', filePath, )
            fs.appendFileSync(path.join('bin', filePath), fs.readFileSync(path.join('libs', libPath), 'utf8') + '\n')
            libsImported++
        } else {
            fs.appendFileSync(path.join('bin', filePath), line + '\n')
        }
    })
    filesDone++
})

console.log('Imported', libsImported, 'libraries total between', filesDone, 'files, with', errors, 'errors')